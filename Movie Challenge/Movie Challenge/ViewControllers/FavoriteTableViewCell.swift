//
//  FavoriteTableViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 11/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteTableViewCell : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    private var moviePage = MoviePageDTO()
    
    override func awakeFromNib() {
        _ = MovieService.shared().findAllFromAPI(query: "Senhor"){ newMoviePage in
            self.moviePage = newMoviePage
            
            DispatchQueue.main.async() {
                self.favoriteCollectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePage.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionCell", for: indexPath) as! FavoriteCollectionViewCell
        
        let movie = moviePage.results[indexPath.row]
        
        cell.titleLabelView.text = movie.title
        cell.poster_path = movie.poster_path
        
        if(movie.poster_path != nil){
            _ = MovieService.shared().getPosterFromAPI(path: movie.poster_path!, quality: Quality.low) { image in
                
                DispatchQueue.main.async() {
                    cell.posterImageView.image = image
                    cell.posterImageView.setNeedsDisplay()
                }
            }
        }
        
        return cell
    }
}
