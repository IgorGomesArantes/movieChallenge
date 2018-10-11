//
//  favoriteMovieCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 19/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

//TODO Tratar os erros no método viewModelStateChange
class FavoriteMovieTableViewCell: UITableViewCell{
    
    //MARK:- Constants
    static let identifier = "favoriteMovieTableCell"
    
    //MARK:- Private variables
    private var viewModel: FavoriteCellViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var voteAverageProgressBar: UIProgressView!
    @IBOutlet weak var categoryCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    //MARK:- View actions
    @IBAction func sendToDetailClick(_ sender: Any) {
        viewModel.gotoDetailScene()
    }
    
    @IBAction func removeFavoriteClick(_ sender: Any) {
        viewModel.removeFromFavorite()
    }
    
    //MARK:- Primitive methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryCollection.register(UINib(nibName: GenreCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        posterImage.setLittleBorderFeatured()
        titleView.setCornerRadius()
        setLittleBorderFeatured()
    }
    
    //MARK:- Private methods
    private func setFields(){
        
        posterImage.sd_setImage(with: URL(string: viewModel.posterPath), placeholderImage: UIImage(named: AppConstants.placeHolder))
        
        titleLabel.text = viewModel.title
        voteCountLabel.text = viewModel.voteCount
        voteAverageLabel.text = viewModel.voteAverage
        creationDateLabel.text = viewModel.creationDate
        voteAverageProgressBar.progress = viewModel.progressBarScore
    
        let height = self.categoryCollection.collectionViewLayout.collectionViewContentSize.height
        self.categoryCollectionHeightConstraint.constant = height
        
        categoryCollection.reloadData()
    }
    
    //MARK:- Public methods
    func setup(viewModel: FavoriteCellViewModel){
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        self.viewModel = viewModel
        
        bindViewModel()
        
        self.viewModel.reload()
    }
}

//MARK:- FavoriteMovieTableViewCell methods
extension FavoriteMovieTableViewCell: MovieViewController{
    func viewModelStateChange(change: MovieState.Change) {
        switch change {
        case .success:
            setFields()
            break
        default:
            break
        }
    }
    
    func bindViewModel() {
        viewModel.onChange = viewModelStateChange
    }
}

//MARK:- Collection methods
extension FavoriteMovieTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        
        cell.setup(viewModel: viewModel.getGenreViewModel(index: indexPath.row))
        
        return cell
    }
}
