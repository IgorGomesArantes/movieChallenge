//
//  NewDetailViewControll.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 05/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private var movie = MovieDTO()
    private var imageDownloadTask: URLSessionDataTask!
    private var movieId: Int!
    private var favorite: Bool!

    @IBOutlet weak var overviewLabelView: UILabel!
    @IBOutlet weak var numberOfVotesLabelView: UILabel!
    @IBOutlet weak var pointsLabelView: UILabel!
    @IBOutlet weak var runtimeLabelView: UILabel!
    @IBOutlet weak var yearLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var favoriteButtonView: UIButton!
    @IBOutlet weak var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func favoriteMovie(_ sender: Any) {
        if(favorite){
            do{
                try MovieRepository.shared().remove(id: movieId)
                favorite = false
                setButtonState()
                
                print("Removeu")
            }catch let error{
                print("Erro ao deletar o filme", error)
            }
            
        }else{
            do{
                try MovieRepository.shared().save(movie: movie)
                favorite = true
                setButtonState()
                
                print("Salvou")
            }catch let error{
                print("Erro ao salvar o filme", error)
            }
        }
    }
    
    private func setPoster(poster: UIImage){
        DispatchQueue.main.async() {
            self.posterImageView.image = poster
            self.posterImageView.setNeedsDisplay()
        }
    }
    
    private func setButtonState(){
        if(favorite){
            DispatchQueue.main.async(){
                self.favoriteButtonView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.favoriteButtonView.setTitle("Remover", for: UIControlState.normal)
            }
        }else{
            DispatchQueue.main.async(){
                self.favoriteButtonView.backgroundColor = #colorLiteral(red: 1, green: 0.6116010603, blue: 0.006196474039, alpha: 1)
                self.favoriteButtonView.setTitle("Favoritar", for: UIControlState.normal)
            }
        }
    }
    
    override func viewDidLoad() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        self.movieId = movieId ?? 76341
        
        do{
            self.movie = try MovieRepository.shared().getOne(by: movieId)
            self.favorite = true
            self.setButtonState()
            self.fillFields()
        }catch{
            self.favorite = false
            
            _ = MovieService.shared().getMovieDetail(id: movieId){ movie, response, error in
                self.movie = movie
                self.setButtonState()
                self.fillFields()
            }
        }
    }
    
    public func setUp(movieId: Int?){
        //TODO MAD MAX CODE
        self.movieId = movieId ?? 76341
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let genres = movie.genres else { return 0 }
        
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        guard let categoryList = movie.genres else{ return UICollectionViewCell() }
        cell.setUp(name: categoryList[indexPath.row].name)
        
        return cell
    }
    
    func fillFields(){
        DispatchQueue.main.async(){
            
            self.titleLabelView.text = self.movie.title
            self.pointsLabelView.text = String(self.movie.vote_average!)
            self.numberOfVotesLabelView.text = "(" + String(self.movie.vote_count!) + ")"
            self.overviewLabelView.text = self.movie.overview
            
            if let releaseDate = self.movie.release_date{
                if(!releaseDate.isEmpty){
                    self.yearLabelView.text = String((self.movie.release_date?.split(separator: "-").first)!)
                }
            }
            
            if let runtime = self.movie.runtime{
                self.runtimeLabelView.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
            } else{
                self.runtimeLabelView.text = "Duração indefinida"
            }
            
            self.categoryCollectionView.reloadData()
            
            let height = self.categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.categoryCollectionViewHeightConstraint.constant = height
        }
        
        if let poster = self.movie.poster{
            setPoster(poster: UIImage(data: poster)!)
        }else if let posterPath = self.movie.poster_path{
            _ = MovieService.shared().getPoster(path: posterPath, quality: Quality.high) { image, response, error in
                self.movie.poster = UIImagePNGRepresentation(image)
                self.setPoster(poster: image)
            }
        }
    }
}
