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
    
    //MARK:- Private variables
    private var movie = MovieDTO()
    private var imageDownloadTask: URLSessionDataTask!
    private var movieId: Int!
    private var favorite: Bool!

    //MARK:- View variables
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var votesAverageLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var categoryCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var overviewView: UIView!
    
    //MARK:- View actions
    @IBAction func favoriteMovie(_ sender: Any) {
        if favorite{
            do{
                try MovieRepository.shared().removeMovie(id: movieId)
                favorite = false
                self.setButtonState()
                
            }catch let error{
                print("Erro ao deletar o filme", error)
            }
        }else{
            do{
                try MovieRepository.shared().saveMovie(movie: movie)
                favorite = true
                self.setButtonState()
                
            }catch let error{
                print("Erro ao salvar o filme", error)
            }
        }
    }
    
    //MARK:- Primitive functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self

        categoryCollection.setBorderFeatured()
        favoriteButton.setCornerRadius()
        overviewView.setBorderFeatured()
        titleLabel.setCornerRadius()
        
        do{
            self.movie = try MovieRepository.shared().getMovie(by: movieId)
            self.favorite = true
            
            DispatchQueue.main.async {
                self.setButtonState()
                self.setFields()
            }
        }catch{
            self.favorite = false
            
            MovieService.shared().getMovieDetail(id: movieId){ movie, response, error in
                self.movie = movie
                DispatchQueue.main.async {
                    self.setButtonState()
                    self.setFields()
                }
            }
        }
    }
    
    //MARK:- Private Functions
    private func setPoster(poster: UIImage){
        self.posterImage.image = poster
        self.posterImage.setNeedsDisplay()
    }
    
    private func setButtonState(){
        if favorite{
            self.favoriteButton.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
            self.favoriteButton.setTitle("Remover", for: UIControl.State.normal)
            self.favoriteButton.setTitleColor(#colorLiteral(red: 0.9449999928, green: 0.7689999938, blue: 0.05900000036, alpha: 1), for: UIControl.State.normal)
        }else{
            self.favoriteButton.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.6274509804, blue: 0.5215686275, alpha: 1)
            self.favoriteButton.setTitle("Favoritar", for: UIControl.State.normal)
            self.favoriteButton.setTitleColor(#colorLiteral(red: 0.1609999985, green: 0.5019999743, blue: 0.7250000238, alpha: 1), for: UIControl.State.normal)
        }
    }
    
    func setFields(){
        self.titleLabel.text = self.movie.title
        self.votesAverageLabel.text = String(self.movie.vote_average!)
        self.votesCountLabel.text = "(" + String(self.movie.vote_count!) + ")"
        self.overviewLabel.text = self.movie.overview
        
        if let releaseDate = self.movie.release_date{
            if !releaseDate.isEmpty{
                self.yearLabel.text = String((self.movie.release_date?.split(separator: "-").first)!)
            }
        }
        
        if let runtime = self.movie.runtime{
            self.runtimeLabel.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
        } else{
            self.runtimeLabel.text = "Duração indefinida"
        }
        
        self.categoryCollection.reloadData()
        
        let height = self.categoryCollection.collectionViewLayout.collectionViewContentSize.height
        self.categoryCollectionHeightConstraint.constant = height
        
        if let poster = self.movie.poster{
            setPoster(poster: UIImage(data: poster)!)
        }else if let posterPath = self.movie.poster_path{
            MovieService.shared().getPoster(path: posterPath, quality: Quality.high) { image, response, error in
                self.movie.poster = image.pngData()
                self.setPoster(poster: image)
            }
        }
    }
    
    //MARK:- Public functions
    public func setUp(movieId: Int?){
        self.movieId = movieId
    }
}

//MARK:- Collection View Methods
extension DetailViewController :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let genres = movie.genres else { return 0 }
        
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        guard let categoryList = movie.genres, let categoryName = categoryList[indexPath.row].name else{ return UICollectionViewCell() }

        cell.setUp(name: categoryName)
        
        return cell
    }
}
