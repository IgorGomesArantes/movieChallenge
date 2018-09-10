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

    @IBOutlet weak var overviewLabelView: UILabel!
    @IBOutlet weak var numberOfVotesLabelView: UILabel!
    @IBOutlet weak var pointsLabelView: UILabel!
    @IBOutlet weak var runtimeLabelView: UILabel!
    @IBOutlet weak var yearLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private var movieDTO: MovieDTO!
    public var movieId: Int!
    private var imageDownloadTask: URLSessionDataTask!
    
    
    override func viewDidLoad() {
        
        movieId = 76341
        
        _ = MovieService.shared().findOneFromAPI(id: movieId){ movie in
            self.movieDTO = movie
            
            self.fillFields(movie: self.movieDTO)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! DetailCollectionViewCell
        
        let result = movieDTO.genres![indexPath.row]
        
        DispatchQueue.main.async {
            cell.nameLabelView.text = result.name
        }
        
        return cell
    }
    
    func fillFields(movie: MovieDTO){

        DispatchQueue.main.async() {
            self.titleLabelView.text = movie.title
            self.pointsLabelView.text = String(movie.vote_average!)
            self.numberOfVotesLabelView.text = "(" + String(movie.vote_count!) + ")"
            self.overviewLabelView.text = movie.overview
            
            if(movie.release_date != nil && !(movie.release_date?.isEmpty)!){
                self.yearLabelView.text = String((movie.release_date?.split(separator: "-").first!)!)
            }
            
            if let runtime = movie.runtime{
                let hours = Int(runtime / 60)
                let minutes = Int(runtime % 60)
                
                self.runtimeLabelView.text = String(hours) + "h" + String(minutes) + "m"
            }
            
            self.categoryCollectionView.reloadData()
        }
        
        if(movie.poster == nil){
            if(movie.poster_path != nil){
                
                imageDownloadTask = MovieService.shared().getPosterFromAPI(path: movie.poster_path!, quality: Quality.high) { image in
                    
                    DispatchQueue.main.async() {
                        self.posterImageView.image = image
                        self.posterImageView.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteMovie(_ sender: Any) {
        
        do{
            try MovieRepository.shared().save(movie: movieDTO)
            print("Salvou")
        }catch let error{
            print("Erro ao salvar o filme", error)
        }
    }
}
