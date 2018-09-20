//
//  favoriteMovieCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 19/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteMovieTableViewCell: UITableViewCell{
    
    //MARK:- Private variables
    private var movie: MovieDTO!
    
    //MARK:- View variables
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var voteAverageProgressBar: UIProgressView!
    @IBOutlet weak var categoryCollectionHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Primitive methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImage.setLittleBorderFeatured()
        titleView.setCornerRadius()
    }
    
    //MARK:- Private methods
    private func setFields(){
        titleLabel.text = movie.title
        yearLabel.text = String(movie.release_date!)
        creationDateLabel.text = "Hoje"//String(movie.creation_date!)
        voteAverageProgressBar.progress = movie.vote_average! / 10.0
        posterImage.image = movie.poster != nil ? UIImage(data: movie.poster!) : UIImage(named: "placeholder-image")
    
        let height = self.categoryCollection.collectionViewLayout.collectionViewContentSize.height
        self.categoryCollectionHeightConstraint.constant = height
        
        categoryCollection.reloadData()
    }
    
    //MARK:- Public methods
    func setUp(movie: MovieDTO){
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        self.movie = movie
        
        setFields()
    }
}

extension FavoriteMovieTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let genres = movie.genres else{ return 0 }
        
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCategoryCollectionViewCell", for: indexPath) as! FavoriteCategoryCollectionViewCell
        
        guard let genres = movie.genres else { return UICollectionViewCell()}
        guard let category = genres[indexPath.row].name else { return UICollectionViewCell() }
        
        cell.setUp(name: category)
        
        return cell
    }
}
