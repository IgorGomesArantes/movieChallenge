//
//  SuggestionTableViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var categoryLabelView: UILabel!
    @IBOutlet weak var suggestionMoviesCollectionView: UICollectionView!
    @IBOutlet weak var suggestionHeaderView: UIView!
    
    private var moviePage = MoviePageDTO()
    private var sort: Sort!
    private var posters = [UIImage]()
    private var getPosterTasks: [URLSessionDataTask]!
    
    override func awakeFromNib() {
        getPosterTasks = [URLSessionDataTask]()
        categoryLabelView.setCornerRadius()
    }
    
    func setUp(moviePage: MoviePageDTO){
        suggestionMoviesCollectionView.delegate = self
        suggestionMoviesCollectionView.dataSource = self
        
        self.moviePage = moviePage
        
        if(getPosterTasks != nil){
            for task in getPosterTasks{
                task.cancel()
            }
            getPosterTasks.removeAll()
        }
        
        self.posters.removeAll()

        categoryLabelView.text = moviePage.label
        
        for movie in moviePage.results{
            if let posterPath = movie.poster_path{
                let task = MovieService.shared().getPoster(path: posterPath, quality: Quality.low){ poster, response, error in
                    self.posters.append(poster)
                    DispatchQueue.main.async(){
                        self.suggestionMoviesCollectionView.reloadData()
                    }
                }
                getPosterTasks.append(task)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionMovieCollectionViewCell", for: indexPath) as! SuggestionCollectionViewCell
        
        cell.setUp(poster: posters[indexPath.row])
        
        return cell
    }
}
