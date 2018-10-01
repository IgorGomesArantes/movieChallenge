//
//  SearchCollectionViewController.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 03/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : BaseMovieViewController{

    //MARK:- View variables
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    //MARK:- Primitive functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewModelStateChange(change: MovieListState.Change) {
        switch change {
        case .success:
            movieCollection.reloadData()
            break
        case .error:
            movieCollection.showEmptyCell(string: "Erro ao buscar os filmes")
            break
        }
    }
    
    override func bindViewModel(){
        viewModel = SearchViewModel()
        viewModel.onChange = viewModelStateChange
    }
    
    //TODO Coordinator
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "searchCollectionToMovieDetail"{
            
            let indexPathArray = movieCollection.indexPathsForSelectedItems! as NSArray
            let indexPath = indexPathArray.firstObject as! NSIndexPath
            
            let selectedMovie = self.viewModel.state!.moviePage.results[indexPath.row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.setUp(movieId: selectedMovie.id)
        }
    }
}

//MARK:- Search View Methods
extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchViewModel = viewModel as? SearchViewModel{
            searchViewModel.searchQuery = searchBar.text
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchViewModel = viewModel as? SearchViewModel{
            searchViewModel.searchQuery = ""
        }
    }
}

//MARK:- Collection view methods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if viewModel.state!.moviePage.results.isEmpty{
            movieCollection.showEmptyCell(string: "Busque por filmes")
            
            return 0
        }
        
        movieCollection.hideEmptyCell()
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state!.moviePage.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionViewCell
        
        let movie: MovieDTO = viewModel.state!.moviePage.results[indexPath.row]
        
        cell.setUp(posterURL: movie.poster_path ?? "")
        
        return cell
    }
}
