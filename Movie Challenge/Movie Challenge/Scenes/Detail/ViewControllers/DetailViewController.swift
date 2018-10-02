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
    var viewModel: MovieViewModel!
    
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
        if let viewModel = viewModel as? DetailViewModel{
            viewModel.saveMovieOrRemoveFavorite()
            self.setButtonState()
        }
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
        
        if let viewModel = viewModel as? DetailViewModel{
            viewModel.movieId = movieId
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setButtonState()
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
    private func setButtonState(){
        let movieDetail = viewModel.getMovie()
        guard let favorite = movieDetail.favorite else { return }
        
        if favorite{
            self.favoriteButton.backgroundColor = AppConstants.colorPattern
            self.favoriteButton.setTitle("Remover", for: UIControl.State.normal)
            self.favoriteButton.setTitleColor(AppConstants.colorFeatured, for: UIControl.State.normal)
        }else{
            self.favoriteButton.backgroundColor = AppConstants.colorFeatured
            self.favoriteButton.setTitle("Favoritar", for: UIControl.State.normal)
            self.favoriteButton.setTitleColor(AppConstants.colorPattern, for: UIControl.State.normal)
        }
    }
    
    func setFields(){
        let movieDetail = viewModel.getMovie()
        
        titleLabel.text = movieDetail.title
        votesAverageLabel.text = String(movieDetail.vote_average!)
        votesCountLabel.text = "(" + String(movieDetail.vote_count!) + ")"
        overviewLabel.text = movieDetail.overview
        
        if let releaseDate = movieDetail.release_date{
            if !releaseDate.isEmpty{
                yearLabel.text = String((movieDetail.release_date?.split(separator: "-").first)!)
            }
        }
        
        if let runtime = movieDetail.runtime{
            runtimeLabel.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
        } else{
            runtimeLabel.text = "Duração indefinida"
        }
        
        categoryCollection.reloadData()
        
        let height = categoryCollection.collectionViewLayout.collectionViewContentSize.height
        categoryCollectionHeightConstraint.constant = height
        
        if let posterPath = movieDetail.poster_path{
            posterImage.sd_setImage(with: URL(string: AppConstants.BaseImageURL + Quality.high.rawValue + "/" + posterPath), placeholderImage: UIImage(named: AppConstants.placeHolder))
        }
    }
    
    //MARK:- Public functions
    public func setUp(movieId: Int?){
        self.movieId = movieId
    }
}

//MARK:- Collection View Methods
extension DetailViewController :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let movieDetail = viewModel.getMovie()
        guard let genres = movieDetail.genres else { return 0 }
        
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        let movieDetail = viewModel.getMovie()
        guard let categoryList = movieDetail.genres, let categoryName = categoryList[indexPath.row].name else{ return UICollectionViewCell() }

        cell.setUp(name: categoryName)
        
        return cell
    }
}
