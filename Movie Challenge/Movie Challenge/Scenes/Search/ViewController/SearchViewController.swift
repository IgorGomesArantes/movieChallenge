//
//  SearchCollectionViewController.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 03/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : UIViewController, MovieViewController{
    
    //MARK:- ViewModel
    var viewModel: SearchViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    //MARK:- Primitive functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollection.showEmptyCell(string: "Buscar filmes")
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }
    
    func bindViewModel() {
        viewModel = SearchViewModel(onChange: viewModelStateChange)
    }
    
    func viewModelStateChange(change: MovieState.Change) {
        switch change {
        case .success:
            movieCollection.hideEmptyCell()
            break
        case .error:
            movieCollection.showEmptyCell(string: "Erro ao buscar os filmes")
            break
        case .emptyResult:
            movieCollection.showEmptyCell(string: "Buscar filmes")
            break
        }
        
        movieCollection.reloadData()
    }
    
    //TODO Coordinator
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "searchCollectionToMovieDetail"{
            
            let indexPathArray = movieCollection.indexPathsForSelectedItems! as NSArray
            let indexPath = indexPathArray.firstObject as! NSIndexPath
            
            let selectedMovie = self.viewModel.movie(row: indexPath.row)
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.setUp(movieId: selectedMovie.id)
        }
    }
}

//MARK:- Search View Methods
extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = searchBar.text
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            viewModel.searchQuery = searchText
        }
    }
}

//MARK:- Collection view methods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionViewCell
        
        let movie: MovieDTO = viewModel.movie(row: indexPath.row)
        
        cell.setUp(posterURL: movie.poster_path ?? "")
        
        return cell
    }
}
