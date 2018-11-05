//
//  HomeViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

//TODO:- Tratar os erros de viewModelStateChange 
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
        
        bestMovieGenreCollection.register(UINib(nibName: GenreCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        
        bestMovieGenreCollection.delegate = self
        bestMovieGenreCollection.dataSource = self
        
        bestMovieImage.setLittleBorderFeatured()
        bestMovieView.setLittleBorderFeatured()

        viewModel = HomeViewModel(service: HTTPMovieService())
        bindViewModel()
        viewModel.reload()
    }
    
    //MARK:- Private methods
    private func setBestMovie(){
        bestMovieImage.sd_setImage(with: URL(string: viewModel.posterPath), placeholderImage: UIImage(named: AppConstants.placeHolder))
        
        self.bestMovieYearLabel.text = viewModel.year
        self.bestMovieTitleLabel.text = viewModel.title
        self.bestMovieRuntimeLabel.text = viewModel.runtime
        self.bestMovieVotesCountLabel.text = viewModel.voteCount
        self.bestMovieVotesAverageLabel.text = viewModel.voteAverage
        
        self.bestMovieGenreCollection.reloadData()
        let height = self.bestMovieGenreCollection.collectionViewLayout.collectionViewContentSize.height
        self.bestMovieGenreCollectionHeightConstraint.constant = height
        
        self.suggestionTable.reloadData()
    }
}

//MARK:- SuggestionCellViewModelDelegate methods
extension HomeViewController: SuggestionCellViewModelDelegate {
    func changeToMovieDetail(movieId: Int) {
        if let viewController = UIStoryboard(name: AppConstants.storyBoardName, bundle: nil).instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController {
            viewController.setup(viewModel: DetailViewModel(movieId: movieId, service: HTTPMovieService(), repository: MovieRepository()))
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

//MARK:- MoviewViewController methods
extension HomeViewController: ViewControllerProtocol{
    func viewModelStateChange(change: MovieState.Change) {
        switch change {
        case .success:
            self.setBestMovie()
            break
        default:
            break
        }
    }
    
    func bindViewModel() {
        viewModel.onChange = viewModelStateChange
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionTableViewCell.identifier, for: indexPath) as! SuggestionTableViewCell
        
        cell.setup(viewModel: viewModel.getSuggestionCellViewModel(index: indexPath.row, delegate: self))
        
        return cell
    }
}

//MARK:- Collection view methods
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        
        cell.setup(viewModel: viewModel.getGenreViewModel(index: indexPath.row))
        
        return cell
    }
}
