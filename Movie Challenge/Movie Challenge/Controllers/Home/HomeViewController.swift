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
    private var bestMovie: MovieDTO!
    private var moviePageList: [MoviePageDTO]!
    
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
        
        bestMovieImage.setBorderFeatured()
        bestMovieTitleLabel.setCornerRadius()
        bestMovieView.setBigBorderFeatured()
        
        setMoviePageList()
    }
    
    //MARK:- Private methods
    private func setBestMovie(movie: MovieDTO){
        
        bestMovie = movie
        
        MovieService.shared().getPoster(path: movie.poster_path!, quality: Quality.high){ poster, response, error in
            self.bestMovieImage.image = poster
        }
        
        self.bestMovieTitleLabel.text = movie.title
        self.bestMovieVotesAverageLabel.text = String(movie.vote_average!)
        self.bestMovieVotesCountLabel.text = "(" + String(movie.vote_count!) + ")"
        
        if let releaseDate = movie.release_date{
            if !releaseDate.isEmpty{
                self.bestMovieYearLabel.text = String((releaseDate.split(separator: "-").first)!)
            }
        }
        
        if let runtime = movie.runtime{
            self.bestMovieRuntimeLabel.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
        } else{
            self.bestMovieRuntimeLabel.text = "Duração indefinida"
        }
        
        self.bestMovieCategoryCollection.reloadData()
        let height = self.bestMovieCategoryCollection.collectionViewLayout.collectionViewContentSize.height
        self.bestMovieCategoryCollectionHeightConstraint.constant = height
    }
    
    private func searchMoviePage(sort: Sort, order: Order, label: String, isBestMovieHere: Bool){
        MovieService.shared().getMoviePage(sort: sort, order: order){ newMoviePage, response, error in
            var moviePage = newMoviePage
            moviePage.label = label
            self.moviePageList.append(moviePage)
            
            if isBestMovieHere{
                if let bestMovie = moviePage.results.first{
                    MovieService.shared().getMovieDetail(id: bestMovie.id!){ movie, response, error in
                        self.setBestMovie(movie: movie)
                    }
                }
            }
            
            DispatchQueue.main.async(){
                self.suggestionTable.reloadData()
            }
        }
    }
    
    private func searchTrendingMoviePage(label: String){
        MovieService.shared().getTrendingMovies(){ newMoviePage, response, error in
            var moviePage = newMoviePage
            moviePage?.label = label
            self.moviePageList.append(moviePage!)
            
            DispatchQueue.main.async(){
                self.suggestionTable.reloadData()
            }
        }
    }
    
    private func setMoviePageList(){
        moviePageList = [MoviePageDTO]()
        
        for i in 0...3{
            switch i{
            case 0:
                searchMoviePage(sort: Sort.popularity, order: Order.descending, label: "Populares da semana", isBestMovieHere: true)
                break
            case 1:
                searchMoviePage(sort: Sort.voteCount, order: Order.descending, label: "Mais votados de todos os tempos", isBestMovieHere: false)
                break
            case 2:
                searchMoviePage(sort: Sort.voteAverage, order: Order.descending, label: "Melhores médias de pontuação", isBestMovieHere: false)
                break
            case 3:
                searchTrendingMoviePage(label: "Melhores do dia")
                break
            default:
                break
            }
        }
    }
}

//MARK:- SendToDetailDelegate methods
extension HomeViewController: SendToDetailDelegate {
    func changeToMovieDetail(movieId: Int) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDetailView") as? DetailViewController {
            viewController.setUp(movieId: movieId)
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

//MARK:- Table view methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviePageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        
        cell.setUp(moviePage: moviePageList[indexPath.row], delegate: self)
        
        return cell
    }
}

//MARK:- Collection view methods
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movie = bestMovie else { return 0 }
        guard let genres = movie.genres else { return 0 }
        
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestMovieCategoryCollectionViewCell", for: indexPath) as! BestMovieCategoryCollectionViewCell
        
        guard let categoryList = bestMovie.genres else{ return UICollectionViewCell() }
        cell.setUp(name: categoryList[indexPath.row].name)
        
        cell.setCornerRadius()
        
        return cell
    }
}
