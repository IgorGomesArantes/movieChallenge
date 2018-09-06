//
//  NewDetailViewControll.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 05/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class NewDetailViewController : UIViewController{
    
    @IBOutlet weak var overviewLabelView: UILabel!
    @IBOutlet weak var numberOfVotesLabelView: UILabel!
    @IBOutlet weak var pointsLabelView: UILabel!
    @IBOutlet weak var runtimeLabelView: UILabel!
    @IBOutlet weak var yearLabelView: UILabel!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private var movieDTO: MovieDTO!
    private var movieId: Int!
    private var imageDownloadTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        
        movieId = 76341
        
        _ = MovieService.shared().findOneFromAPI(id: movieId){ movie in
            self.movieDTO = movie
            
            self.fillFields(movie: self.movieDTO)
        }
    }
    
    func fillFields(movie: MovieDTO){

        DispatchQueue.main.async() {
            self.titleLabelView.text = movie.title
            self.pointsLabelView.text = String(movie.vote_average!)
            self.numberOfVotesLabelView.text = String(movie.vote_count!)
            self.overviewLabelView.text = movie.overview
            
            if let releaseDate = movie.release_date{
                self.yearLabelView.text = String(releaseDate.split(separator: "-").first!)
            }
            
            if let runtime = movie.runtime{
                self.runtimeLabelView.text = String(runtime) ?? "Não há"
            }
            //self.durationLabel.text = String(self.movie.runtime!) ?? "0" + " min"
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
}
