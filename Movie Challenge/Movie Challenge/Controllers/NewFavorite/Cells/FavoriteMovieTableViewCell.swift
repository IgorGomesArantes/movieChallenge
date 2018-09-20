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
    private var delegate: SendToDetailDelegate!
    
    //MARK:- View variables
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var voteAverageProgressBar: UIProgressView!
    @IBOutlet weak var categoryCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    //MARK:- View actions
    @IBAction func sendToDetailClick(_ sender: Any) {
        if let id = movie.id{
            delegate.changeToMovieDetail(movieId: id)
        }
    }
    
    
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
        creationDateLabel.text = movie.creation_date != nil ? movie.creation_date?.toString(dateFormat: "dd-MM-yyyy") : ""
        posterImage.image = movie.poster != nil ? UIImage(data: movie.poster!) : UIImage(named: "placeholder-image")
        voteAverageLabel.text = String(self.movie.vote_average!)
        voteCountLabel.text = "(" + String(self.movie.vote_count!) + ")"
        
        voteAverageProgressBar.progress = movie.vote_average != nil ? movie.vote_average! / 10.0 : 0.0
        
        if let voteAverage = movie.vote_average{
            voteAverageProgressBar.progress = voteAverage / 10.0
        }
    
        let height = self.categoryCollection.collectionViewLayout.collectionViewContentSize.height
        self.categoryCollectionHeightConstraint.constant = height
        
        categoryCollection.reloadData()
    }
    
    //MARK:- Public methods
    func setUp(movie: MovieDTO, delegate: SendToDetailDelegate){
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        self.movie = movie
        self.delegate = delegate
        
        setFields()
    }
}

//MARK:- Collection methods
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
