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
    @IBOutlet weak var bestMovieCategoryCollection: UICollectionView!
    @IBOutlet weak var bestMovieCategoryCollectionHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Primitive methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        
        bestMovieCategoryCollection.delegate = self
        bestMovieCategoryCollection.dataSource = self
        
        bestMovieImage.setLittleBorderFeatured()
        bestMovieView.setLittleBorderFeatured()
        
        //resizeBestMovieView()
        
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
        
        self.bestMovieCategoryCollection.reloadData()
        let height = self.bestMovieCategoryCollection.collectionViewLayout.collectionViewContentSize.height
        self.bestMovieCategoryCollectionHeightConstraint.constant = height
    }

    private func resizeBestMovieView(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        bestMovieView.frame = CGRect(x: bestMovieView.frame.origin.x, y: bestMovieView.frame.origin.y, width: bestMovieView.frame.width, height: (screenWidth * 5.0) / 8.0)
    }
}

//MARK:- SuggestionTableViewCellDelegate methods
extension HomeViewController: SuggestionTableViewCellDelegate {
    func changeToMovieDetail(movieId: Int) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDetailView") as? DetailViewController {
            viewController.setup(movieId: movieId)
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestMovieCategoryCollectionViewCell", for: indexPath) as! BestMovieCategoryCollectionViewCell
        
        cell.setup(genre: viewModel.getGenre(index: indexPath.row))
        
        return cell
    }
}
