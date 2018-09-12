//
//  SearchCollectionViewController.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 03/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class SearchCollectionViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{
    
    private var moviePage = MoviePageDTO()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var searchNewMoviesTask = DispatchWorkItem { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.movieCollectionView.clearsContextBeforeDrawing = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchCollectionToMovieDetail"{
            
            let indexPathArray = movieCollectionView.indexPathsForSelectedItems! as NSArray
            let indexPath = indexPathArray.firstObject as! NSIndexPath
            
            let selectedMovie = self.moviePage.results[indexPath.row]
            
            let detailViewController = segue.destination as! NewDetailViewController
            detailViewController.setUp(movieId: selectedMovie.id)
        }
    }
    
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
            _ = MovieService.shared().getPosterFromAPI(path: posterPath, quality: Quality.low) { image in
                DispatchQueue.main.async() {
                    cell.setUp(poster: image)
                }
            }
        }

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchNewMoviesTask.cancel()
        searchNewMoviesTask = DispatchWorkItem { self.searchMovies(by: searchText) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchNewMoviesTask)
    }
    
    private func searchMovies(by searchText: String){
        _ = MovieService.shared().findAllFromAPI(query: searchText){ newMoviePage in
            self.moviePage = newMoviePage
            
            DispatchQueue.main.async() {
                self.movieCollectionView.reloadData()
            }
        }
    }
}
