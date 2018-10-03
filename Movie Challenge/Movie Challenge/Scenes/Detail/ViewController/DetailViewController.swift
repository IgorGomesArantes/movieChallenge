//
//  NewDetailViewControll.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 05/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController, MovieViewController{
    
    //MARK:- MovieViewController variables
    var viewModel: DetailViewModel!
    
    //MARK:- Private variables
    private var movieId: Int!

    //MARK:- View variables
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var votesAverageLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var categoryCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var overviewView: UIView!
    
    //MARK:- View actions
    @IBAction func favoriteMovie(_ sender: Any) {
        viewModel.saveMovieOrRemoveFavorite()
        self.setButtonState()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- Primitive functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self

        titleLabel.setLittleBorderFeatured()
        favoriteButton.setBorderFeatured()
        overviewView.setLittleBorderFeatured()
        titleLabel.setCornerRadius()
        
        viewModel.movieId = movieId
    }
    
    func bindViewModel(){
        viewModel = DetailViewModel(onChange: viewModelStateChange)
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
    
    //MARK:- Private Functions
    //TODO:- Misterio
    private func setButtonState(){
        if viewModel.state.settedUp{
            favoriteButton.isEnabled = true
            
            if (viewModel.movie?.favorite)!{
                self.favoriteButton.backgroundColor = AppConstants.colorPattern
                self.favoriteButton.setTitle("Remover", for: UIControl.State.normal)
                self.favoriteButton.setTitleColor(AppConstants.colorFeatured, for: UIControl.State.normal)
            }else{
                self.favoriteButton.backgroundColor = AppConstants.colorFeatured
                self.favoriteButton.setTitle("Favoritar", for: UIControl.State.normal)
                self.favoriteButton.setTitleColor(AppConstants.colorPattern, for: UIControl.State.normal)
            }
        }else{
            favoriteButton.isEnabled = false
        }
    }
    
    func setFields(){
        if let posterPath = viewModel.movie.poster_path{
            posterImage.sd_setImage(with: URL(string: AppConstants.BaseImageURL + Quality.high.rawValue + "/" + posterPath), placeholderImage: UIImage(named: AppConstants.placeHolder))
        }
        
        titleLabel.text = viewModel.movie.title
        votesAverageLabel.text = String(viewModel.movie.vote_average!)
        votesCountLabel.text = "(" + String(viewModel.movie.vote_count!) + ")"
        overviewLabel.text = viewModel.movie.overview
        
        if let releaseDate = viewModel.movie.release_date{
            if !releaseDate.isEmpty{
                yearLabel.text = String((viewModel.movie.release_date?.split(separator: "-").first)!)
            }
        }
        
        if let runtime = viewModel.movie.runtime{
            runtimeLabel.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
        } else{
            runtimeLabel.text = "Duração indefinida"
        }
        
        categoryCollection.reloadData()
        
        let height = categoryCollection.collectionViewLayout.collectionViewContentSize.height
        categoryCollectionHeightConstraint.constant = height
        
        setButtonState()
    }
    
    //MARK:- Public functions
    public func setUp(movieId: Int?){
        self.movieId = movieId
    }
}

//MARK:- Collection View Methods
extension DetailViewController :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.setUp(genre: viewModel.getGenre(index: indexPath.row))
        
        return cell
    }
}
