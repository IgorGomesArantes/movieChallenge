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

    var moviePage = MoviePageDTO()
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePage.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionViewCell
        
        if let result: MovieDTO? = moviePage.results[indexPath.row]{
            if let posterPath = result?.poster_path{
                _ = MovieService.shared().getPosterFromAPI(path: posterPath, quality: Quality.low) { image in
                    
                    DispatchQueue.main.async() {
                        cell.posterImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchCollectionToMovieDetail"{
            
            let indexPathArray = movieCollectionView.indexPathsForSelectedItems! as NSArray
            
            let indexPath = indexPathArray[0] as! NSIndexPath
                
            let selectedMovie = self.moviePage.results[indexPath.row]
                
            let destinationViewController = segue.destination as! DetailViewController
            destinationViewController.movie = selectedMovie
            destinationViewController.movieId = selectedMovie.id
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(moviePage.results[indexPath.row].title ?? "Nulo")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if(searchText == ""){
            self.moviePage = MoviePageDTO()

            DispatchQueue.main.async() {
                self.movieCollectionView.reloadData()
            }
            
        }else{
            _ = MovieService.shared().findAllFromAPI(query: searchText){ newMoviePage in
                self.moviePage = newMoviePage
                
                DispatchQueue.main.async() {
                    self.movieCollectionView.reloadData()
                }
            }
        }

    }
    
}
