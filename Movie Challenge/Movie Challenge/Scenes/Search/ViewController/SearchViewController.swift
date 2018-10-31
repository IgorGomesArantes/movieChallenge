//
//  SearchCollectionViewController.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 03/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : UIViewController{
    
    //MARK:- Private variables
    private var viewModel: SearchViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    //MARK:- Primitive functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollection.showEmptyCell(string: NSLocalizedString("SearchMovies", comment: ""))
        hideKeyboardWhenTappedAround()
        
        viewModel = SearchViewModel(service: HTTPMovieService())
        bindViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "searchCollectionToMovieDetail"{
            
            let indexPathArray = movieCollection.indexPathsForSelectedItems! as NSArray
            let indexPath = indexPathArray.firstObject as! NSIndexPath
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.setup(viewModel: viewModel.getDetailViewModel(index: indexPath.row))
        }
    }
}

//MARK:- MovieViewController methods
extension SearchViewController: ViewControllerProtocol{
    func bindViewModel() {
        viewModel.onChange = viewModelStateChange
    }
    
    func viewModelStateChange(change: MovieState.Change) {
        
        movieCollection.reloadData()
        
        switch change {
        case .success:
            movieCollection.hideEmptyCell()
            break
        case .error:
            movieCollection.showEmptyCell(string: NSLocalizedString("SearchMoviesError", comment: ""))
            break
        case .emptyResult:
            movieCollection.showEmptyCell(string: NSLocalizedString("SearchMovies", comment: ""))
            break
        }
    }
}

//MARK:- Search View Methods
extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = searchBar.text ?? ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            viewModel.searchQuery = searchText
        }
    }
}

//MARK:- Collection view methods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell

        cell.setup(viewModel: viewModel.getSearchCellViewModel(index: indexPath.row))
        
        return cell
    }
}
