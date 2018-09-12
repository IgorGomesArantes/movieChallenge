//
//  NewDetailViewControll.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 05/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class NewDetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private var movieDTO: MovieDTO!
    private var imageDownloadTask: URLSessionDataTask!
    private var movieId: Int!

    @IBOutlet weak var overviewLabelView: UILabel!
    @IBOutlet weak var numberOfVotesLabelView: UILabel!
    @IBOutlet weak var pointsLabelView: UILabel!
    @IBOutlet weak var runtimeLabelView: UILabel!
    @IBOutlet weak var yearLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBAction func favoriteMovie(_ sender: Any) {
        do{
            try MovieRepository.shared().save(movie: movieDTO)
            print("Salvou")
        }catch let error{
            print("Erro ao salvar o filme", error)
        }
    }
    
    override func viewDidLoad() {
        _ = MovieService.shared().findOneFromAPI(id: movieId){ movie in
            self.movieDTO = movie
            self.fillFields(movie: self.movieDTO)
        }
    }
    
    public func setUp(movieId: Int?){
        //TODO MAD MAX CODE
        self.movieId = movieId ?? 76341
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(movieDTO != nil){
            return (movieDTO.genres?.count)!
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        guard let categoryList = movieDTO.genres else{ return UICollectionViewCell() }
        cell.setUp(name: categoryList[indexPath.row].name)
        
        return cell
    }
    
    func fillFields(movie: MovieDTO){
        
        DispatchQueue.main.async(){
            self.titleLabelView.text = movie.title
            self.pointsLabelView.text = String(movie.vote_average!)
            self.numberOfVotesLabelView.text = "(" + String(movie.vote_count!) + ")"
            self.overviewLabelView.text = movie.overview
            
            if let releaseDate = movie.release_date{
                if(!releaseDate.isEmpty){
                    self.yearLabelView.text = String((movie.release_date?.split(separator: "-").first)!)
                }
            }
            
            if let runtime = movie.runtime{
                self.runtimeLabelView.text = String(runtime / 60) + "h" + String(runtime % 60) + "m"
            } else{
                self.runtimeLabelView.text = "Duração indefinida"
            }
            
            self.categoryCollectionView.reloadData()
        }
        
        if let posterPath = movie.poster_path{
            imageDownloadTask = MovieService.shared().getPosterFromAPI(path: posterPath, quality: Quality.high) { image in
                DispatchQueue.main.async() {
                    self.posterImageView.image = image
                    self.posterImageView.setNeedsDisplay()
                }
            }
        }
    }
}
