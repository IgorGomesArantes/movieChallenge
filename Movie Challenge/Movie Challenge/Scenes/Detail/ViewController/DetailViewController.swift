//
//  NewDetailViewControll.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 05/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

//TODO:- Tratar os erros de viewModelStateChange e viewModelDataBaseChange
class DetailViewController : UIViewController{

    //MARK:- Constants
    static let identifier = "NewDetailView"
    
    //MARK:- Private variables
    private var viewModel: DetailViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var votesAverageLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var genreCollection: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var genreCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var overviewView: UIView!
    
    //MARK:- View actions
    @IBAction func favoriteMovie(_ sender: Any) {
        viewModel.saveMovieOrRemoveFavorite()
    }
    
    //MARK:- Primitive functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollection.register(UINib(nibName: GenreCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        genreCollection.delegate = self
        genreCollection.dataSource = self

        titleLabel.setLittleBorderFeatured()
        favoriteButton.setBorderFeatured()
        overviewView.setLittleBorderFeatured()
        titleLabel.setCornerRadius()
        
        bindViewModel()
        viewModel.reload()
    }
    
    //MARK:- Private Functions
    private func setButtonState(){
        if (viewModel.movie?.favorite)!{
            self.favoriteButton.backgroundColor = AppConstants.colorSecondary
            self.favoriteButton.setTitle(NSLocalizedString("Remove", comment: ""), for: UIControl.State.normal)
            self.favoriteButton.setTitleColor(AppConstants.colorFeatured, for: UIControl.State.normal)
        }else{
            self.favoriteButton.backgroundColor = AppConstants.colorFeatured
            self.favoriteButton.setTitle(NSLocalizedString("Favorite", comment: ""), for: UIControl.State.normal)
            self.favoriteButton.setTitleColor(AppConstants.colorSecondary, for: UIControl.State.normal)
        }
    }
    
    private func setFields(){
        
        posterImage.sd_setImage(with: URL(string: viewModel.posterPath), placeholderImage: UIImage(named: AppConstants.placeHolder))
        
        yearLabel.text = viewModel.year
        titleLabel.text = viewModel.title
        runtimeLabel.text = viewModel.runtime
        overviewLabel.text = viewModel.overview
        votesCountLabel.text = viewModel.voteCount
        votesAverageLabel.text = viewModel.voteAverage
        
        genreCollection.reloadData()
        
        let height = genreCollection.collectionViewLayout.collectionViewContentSize.height
        genreCollectionHeightConstraint.constant = height
        
        setButtonState()
    }
    
    //MARK:- Public functions
    public func setup(viewModel: DetailViewModel){
        self.viewModel = viewModel
    }
}

//MARK:- MovieViewController methods
extension DetailViewController: MovieViewController{
    func bindViewModel(){
        viewModel.onChange = viewModelStateChange
        viewModel.onChangeDataBase = viewModelDataBaseChange
    }
    
    func viewModelStateChange(change: MovieState.Change) {
        switch change {
        case .success:
            setFields()
            break
        case .error:
            break
        case .emptyResult:
            break
        }
    }
}

//MARK:- DataBaseViewController methods
extension DetailViewController: DataBaseViewController{
    func viewModelDataBaseChange(change: MovieState.Change) {
        switch change {
        case .success:
            setButtonState()
            break
        case .error:
            break
        case .emptyResult:
            break
        }
    }
}

//MARK:- Collection View Methods
extension DetailViewController :  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        
        cell.setup(viewModel: viewModel.getGenreViewModel(index: indexPath.row))
        
        return cell
    }
}
