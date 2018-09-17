//
//  HomeViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var bestMovieView: UIView!
    @IBOutlet weak var bestMovieImageView: UIImageView!
    @IBOutlet weak var bestMovieTitleLabelView: UILabel!
    @IBOutlet weak var bestMoviePointsLabelView: UILabel!
    @IBOutlet weak var bestMovieVotesLabelView: UILabel!
    @IBOutlet weak var bestMovieYearLabelView: UILabel!
    @IBOutlet weak var bestMovieRuntimeLabelView: UILabel!
    @IBOutlet weak var bestMovieCategoryCollectionView: UICollectionView!
    @IBOutlet weak var bestMovieCategoryCollectionViewHeightConstraint: NSLayoutConstraint!
    
    private var bestMovie: MovieDTO!
    private var moviePages = [MoviePageDTO]()
    
    override func viewDidLoad() {
        suggestionTableView.delegate = self
        suggestionTableView.dataSource = self
        
        bestMovieCategoryCollectionView.delegate = self
        bestMovieCategoryCollectionView.dataSource = self
        
        bestMovieImageView.setBorderFeatured()
        bestMovieTitleLabelView.setCornerRadius()
        
        for i in 0...2{
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
                default:
                    break
            }

        }
    }
    
    func setBestMovie(movie: MovieDTO){
        
        bestMovie = movie
        
        _ = MovieService.shared().getPoster(path: movie.poster_path!, quality: Quality.high){ poster, response, error in
            DispatchQueue.main.async(){
                self.bestMovieImageView.image = poster
            }
        }
        
        DispatchQueue.main.async(){
            self.bestMovieTitleLabelView.text = movie.title
            self.bestMoviePointsLabelView.text = String(movie.vote_average!)
            self.bestMovieVotesLabelView.text = "(" + String(movie.vote_count!) + ")"
            
            if let releaseDate = movie.release_date{
                if(!releaseDate.isEmpty){
                    self.bestMovieYearLabelView.text = String((releaseDate.split(separator: "-").first)!)
                }
            }
            
            if let runtime = movie.runtime{
                self.bestMovieRuntimeLabelView.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
            } else{
                self.bestMovieRuntimeLabelView.text = "Duração indefinida"
            }
            
            self.bestMovieCategoryCollectionView.reloadData()
            let height = self.bestMovieCategoryCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.bestMovieCategoryCollectionViewHeightConstraint.constant = height
        }
    }
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviePages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        
        cell.setUp(moviePage: moviePages[indexPath.row])
        
        return cell
    }
    
    private func searchMoviePage(sort: Sort, order: Order, label: String, isBestMovieHere: Bool){
        _ = MovieService.shared().getMoviePage(sort: sort, order: order){ newMoviePage, response, error in
            var moviePage = newMoviePage
            moviePage.label = label
            self.moviePages.append(moviePage)
            DispatchQueue.main.async(){
                if(isBestMovieHere){
                    if let bestMovie = moviePage.results.first{
                        _ = MovieService.shared().getMovieDetail(id: bestMovie.id!){ movie, response, error in
                            self.setBestMovie(movie: movie)
                        }
                    }
                }
                self.suggestionTableView.reloadData()
            }
        }
    }
}
