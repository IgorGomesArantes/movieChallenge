//
//  NewDetailViewControll.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 05/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController{
    
    //MARK:- Constants
    private let removeButtonStateString = "Remover"
    private let addButtonStateString = "Favoritar"
    
    //MARK:- Private variables
    private var movieId: Int!
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
    //TODO:- Misterio
    private func setButtonState(){
        if viewModel.state.settedUp{
            if (viewModel.movie?.favorite)!{
                self.favoriteButton.backgroundColor = AppConstants.colorSecondary
                self.favoriteButton.setTitle(removeButtonStateString, for: UIControl.State.normal)
                self.favoriteButton.setTitleColor(AppConstants.colorFeatured, for: UIControl.State.normal)
            }else{
                self.favoriteButton.backgroundColor = AppConstants.colorFeatured
                self.favoriteButton.setTitle(addButtonStateString, for: UIControl.State.normal)
                self.favoriteButton.setTitleColor(AppConstants.colorSecondary, for: UIControl.State.normal)
            }
        }
    }
    
    func setFields(){
        posterImage.sd_setImage(with: URL(string: AppConstants.BaseImageURL + Quality.high.rawValue + "/" + (viewModel.movie.poster_path ?? "")), placeholderImage: UIImage(named: AppConstants.placeHolder))
        
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
            //Erro ao acessar o banco
            //Erro ao remover
            break
        case .emptyResult:
            //O filme não está setado
            break
        }
    }
}

//MARK:- Collection View Methods
extension DetailViewController :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        
        cell.setup(viewModel: viewModel.getGenreViewModel(index: indexPath.row))
        
        return cell
    }
}
