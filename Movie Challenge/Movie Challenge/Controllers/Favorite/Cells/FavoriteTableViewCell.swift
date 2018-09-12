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
    private var category: CategoryDTO!
    
    func setUp(category: CategoryDTO) {
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.reloadData()
        
        self.category = category
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionCell", for: indexPath) as! FavoriteCollectionViewCell
        
        guard let movies = category.movies else {return UICollectionViewCell()}
        let movie = movies[indexPath.row]
        
        cell.setUp(title: movie.title, poster: UIImage(data: movie.poster!))
        
        return cell
    }
}
