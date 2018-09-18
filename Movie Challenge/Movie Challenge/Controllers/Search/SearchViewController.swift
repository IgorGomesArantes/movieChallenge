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
    private var moviePage = MoviePageDTO()
    private var searchNewMoviesTask: DispatchWorkItem!
    
    //MARK:- View variables
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    //MARK:- Primitive functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        searchNewMoviesTask = DispatchWorkItem { }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "searchCollectionToMovieDetail"{
            
            let indexPathArray = movieCollection.indexPathsForSelectedItems! as NSArray
            let indexPath = indexPathArray.firstObject as! NSIndexPath
            
            let selectedMovie = self.moviePage.results[indexPath.row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.setUp(movieId: selectedMovie.id)
        }
    }

    //MARK:- Private Functions
    private func searchMovies(by searchText: String){
        _ = MovieService.shared().getMoviePageByName(query: searchText){ newMoviePage, reponse, error in
            self.moviePage = newMoviePage
            
            DispatchQueue.main.async() {
                self.movieCollection.reloadData()
            }
        }
    }
}

//MARK:- Search View Methods
extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchNewMoviesTask.cancel()
        searchNewMoviesTask = DispatchWorkItem { self.searchMovies(by: searchText) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchNewMoviesTask)
    }
}

//MARK:- Collection view methods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePage.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionViewCell
        
        let movie: MovieDTO = moviePage.results[indexPath.row]
        
        if let posterPath = movie.poster_path{
            _ = MovieService.shared().getPoster(path: posterPath, quality: Quality.low) { image, response, error in
                DispatchQueue.main.async() {
                    cell.setUp(poster: image)
                }
            }
        }
        
        return cell
    }
}
