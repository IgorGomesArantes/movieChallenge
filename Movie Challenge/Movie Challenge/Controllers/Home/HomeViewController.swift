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
    
    override func viewDidLoad() {
        suggestionTableView.delegate = self
        suggestionTableView.dataSource = self
        
        bestMovieCategoryCollectionView.delegate = self
        bestMovieCategoryCollectionView.dataSource = self
        
        _ = MovieService.shared().getMovieDetail(id: 76341){ movie, response, error in
            self.bestMovie = movie
            self.fillFields()
        }
    }
    
    func fillFields(){
        _ = MovieService.shared().getPoster(path: bestMovie.poster_path!, quality: Quality.high){ poster, response, error in
            DispatchQueue.main.async(){
                self.bestMovieImageView.image = poster
            }
        }
        
        DispatchQueue.main.async(){
            self.bestMovieTitleLabelView.text = self.bestMovie.title
            self.bestMoviePointsLabelView.text = String(self.bestMovie.vote_average!)
            self.bestMovieVotesLabelView.text = "(" + String(self.bestMovie.vote_count!) + ")"
            
            if let releaseDate = self.bestMovie.release_date{
                if(!releaseDate.isEmpty){
                    self.bestMovieYearLabelView.text = String((releaseDate.split(separator: "-").first)!)
                }
            }
            
            if let runtime = self.bestMovie.runtime{
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
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        
        cell.setUp()
        
        return cell
    }
}
