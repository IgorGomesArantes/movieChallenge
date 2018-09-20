//
//  SuggestionTableViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell{
    
    //MARK:- Private variables
    private var delegate:SendToDetailDelegate!
    private var moviePage = MoviePageDTO()
    private var sort: Sort!
    private var getPosterTasks: [URLSessionDataTask]!
    
    //MARK:- View variables
    @IBOutlet weak var categoryLabelView: UILabel!
    @IBOutlet weak var suggestionMoviesCollectionView: UICollectionView!
    @IBOutlet weak var suggestionHeaderView: UIView!
    
    //MARK:- Primitive variables
    override func awakeFromNib() {
        super.awakeFromNib()
        
        getPosterTasks = [URLSessionDataTask]()
        categoryLabelView.setCornerRadius()
    }
    
    //MARK:- Public methods
    func setUp(moviePage: MoviePageDTO, delegate: SendToDetailDelegate){
        suggestionMoviesCollectionView.delegate = self
        suggestionMoviesCollectionView.dataSource = self
        
        self.delegate = delegate
        
        self.moviePage = moviePage
        
        if getPosterTasks != nil{
            for task in getPosterTasks{
                task.cancel()
            }
            getPosterTasks.removeAll()
        }

        categoryLabelView.text = moviePage.label
        
        for i in 0 ... moviePage.results.count - 1{
            if let posterPath = moviePage.results[i].poster_path{
                let task = MovieService.shared().getPosterData(path: posterPath, quality: Quality.low){ poster, response, error in
                    self.moviePage.results[i].poster = poster
                    DispatchQueue.main.async(){
                        self.suggestionMoviesCollectionView.reloadData()
                    }
                }
                getPosterTasks.append(task)
            }
        }
    }
}

//MARK: Collection view methods
extension SuggestionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePage.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionMovieCollectionViewCell", for: indexPath) as! SuggestionCollectionViewCell
        
        if let poster = moviePage.results[indexPath.row].poster{
            cell.setUp(poster: UIImage(data: poster)!)
        } else{
            cell.setUp(poster: UIImage(named: "placeholder-image")!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        delegate.changeToMovieDetail(movieId: moviePage.results[indexPath.row].id!)
    }
}
