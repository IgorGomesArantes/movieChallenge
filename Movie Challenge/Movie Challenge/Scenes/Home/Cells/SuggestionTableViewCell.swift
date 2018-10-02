//
//  SuggestionTableViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

protocol SuggestionTableViewCellDelegate{
    func changeToMovieDetail(movieId: Int)
}

class SuggestionTableViewCell: UITableViewCell{
    
    //MARK:- Private variables
    private var delegate: SuggestionTableViewCellDelegate!
    private var moviePage = MoviePageDTO()
    private var getPosterTasks: [URLSessionDataTask]!
    private var page = 2
    private var sort: Sort!
    private var canSearchMore: Bool!
    
    //MARK:- View variables
    @IBOutlet weak var categoryLabelView: UILabel!
    @IBOutlet weak var suggestionMoviesCollectionView: UICollectionView!
    @IBOutlet weak var suggestionHeaderView: UIView!
    @IBOutlet weak var suggestionCategoryView: UIView!
    
    
    //MARK:- Primitive variables
    override func awakeFromNib() {
        super.awakeFromNib()
        
        getPosterTasks = [URLSessionDataTask]()
        suggestionCategoryView.setCornerRadius()
        
        suggestionMoviesCollectionView.setLittleBorderFeatured()
        suggestionCategoryView.setLittleBorderFeatured()
    }
    
    //MARK:- Private methods
    private func updateData(){
        for i in 0 ... moviePage.results.count - 1{
            if let posterPath = moviePage.results[i].poster_path, moviePage.results[i].poster == nil{
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
    
    //MARK:- Public methods
    func setUp(moviePage: MoviePageDTO, delegate: SuggestionTableViewCellDelegate, canSearchMore: Bool, sort: Sort = Sort.popularity){
        suggestionMoviesCollectionView.delegate = self
        suggestionMoviesCollectionView.dataSource = self
        
        self.delegate = delegate
        self.canSearchMore = canSearchMore
        self.sort = sort
        self.moviePage = moviePage
        
        if getPosterTasks != nil{
            for task in getPosterTasks{
                task.cancel()
            }
            getPosterTasks.removeAll()
        }

        categoryLabelView.text = moviePage.label
        
        updateData()
    }
}

//MARK:- MoreMoviesCollectionViewCellDelegate methods
extension SuggestionTableViewCell: MoreMoviesCollectionViewCellDelegate{
    func searchMoreMovies(completion: @escaping () -> ()) {
        MovieService.shared().getMoviePage(page: page, sort: sort, order: Order.descending){ newMoviePage, response, error in
            
            self.moviePage.results.append(contentsOf: newMoviePage.results)
            
            self.page += 1
            
            self.updateData()
            
            completion()
        }
    }
}

//MARK: Collection view methods
extension SuggestionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(canSearchMore){
            return moviePage.results.count + 1
        }
        
        return moviePage.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == moviePage.results.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreMoviesCollectionViewCell", for: indexPath) as! MoreMoviesCollectionViewCell
            
            cell.setUp(delegate: self)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionMovieCollectionViewCell", for: indexPath) as! SuggestionCollectionViewCell
            
            if let poster = moviePage.results[indexPath.row].poster{
                cell.setUp(poster: UIImage(data: poster)!)
            } else{
                cell.setUp(poster: UIImage(named: "placeholder-image")!)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if moviePage.results.count > indexPath.row{
            delegate.changeToMovieDetail(movieId: moviePage.results[indexPath.row].id!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        print("Teste: " + String(indexPath.row))
        
        return true
    }
}