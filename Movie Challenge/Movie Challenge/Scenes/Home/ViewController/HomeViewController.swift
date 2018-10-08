//
//  HomeViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK:- Private variables
    private var viewModel: HomeViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var suggestionTable: UITableView!
    @IBOutlet weak var bestMovieView: UIView!
    @IBOutlet weak var bestMovieImage: UIImageView!
    @IBOutlet weak var bestMovieTitleLabel: UILabel!
    @IBOutlet weak var bestMovieVotesAverageLabel: UILabel!
    @IBOutlet weak var bestMovieVotesCountLabel: UILabel!
    @IBOutlet weak var bestMovieYearLabel: UILabel!
    @IBOutlet weak var bestMovieRuntimeLabel: UILabel!
    @IBOutlet weak var bestMovieGenreCollection: UICollectionView!
    @IBOutlet weak var bestMovieGenreCollectionHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Primitive methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bestMovieGenreCollection.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "genreCollectionViewCell")
        
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        
        bestMovieGenreCollection.delegate = self
        bestMovieGenreCollection.dataSource = self
        
        bestMovieImage.setLittleBorderFeatured()
        bestMovieView.setLittleBorderFeatured()

        bindViewModel()
        viewModel.reload()
    }
    
    //MARK:- Private methods
    private func setBestMovie(){
        bestMovieImage.sd_setImage(with: URL(string: AppConstants.BaseImageURL + Quality.medium.rawValue + "/" + (viewModel.bestMovie.poster_path ?? "")), placeholderImage: UIImage(named: AppConstants.placeHolder))
        
        self.bestMovieTitleLabel.text = viewModel.bestMovie.title
        self.bestMovieVotesAverageLabel.text = String(viewModel.bestMovie.vote_average!)
        self.bestMovieVotesCountLabel.text = "(" + String(viewModel.bestMovie.vote_count!) + ")"
        
        if let releaseDate = viewModel.bestMovie.release_date{
            if !releaseDate.isEmpty{
                self.bestMovieYearLabel.text = String((releaseDate.split(separator: "-").first)!)
            }
        }
        
        if let runtime = viewModel.bestMovie.runtime{
            self.bestMovieRuntimeLabel.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
        } else{
            self.bestMovieRuntimeLabel.text = "Duração indefinida"
        }
        
        self.bestMovieGenreCollection.reloadData()
        let height = self.bestMovieGenreCollection.collectionViewLayout.collectionViewContentSize.height
        self.bestMovieGenreCollectionHeightConstraint.constant = height
    }
}

//MARK:- SuggestionTableViewCellDelegate methods
extension HomeViewController: SuggestionTableViewCellDelegate {
    func changeToMovieDetail(movieId: Int) {
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDetailView") as? DetailViewController {
//            viewController.setup(movieId: movieId)
//            if let navigator = navigationController {
//                navigator.pushViewController(viewController, animated: true)
//            }
//        }
    }
}

//MARK:- MoviewViewController methods
extension HomeViewController: MovieViewController{
    func viewModelStateChange(change: MovieState.Change) {
        switch change {
        case .success:
            if viewModel.bestMovie != nil{
                self.setBestMovie()
            }
            
            self.suggestionTable.reloadData()
            break
        default:
            break
        }
    }
    
    func bindViewModel() {
        viewModel = HomeViewModel(onChange: viewModelStateChange)
    }
}

//MARK:- Table view methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        
        cell.setup(viewModel: viewModel.cellViewlModel(index: indexPath.row, delegate: self))
        
        return cell
    }
}

//MARK:- Collection view methods
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        
        cell.setup(viewModel: viewModel.getGenreViewModel(index: indexPath.row))
        
        return cell
    }
}
