//
//  ViewController.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var averagePointsLabel: UILabel!
    @IBOutlet weak var numberOfVotesLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private var wasSaved = false
    
    public var movie: MovieDTO!
    public var imageDownloadTask: URLSessionDataTask!
    @IBOutlet weak var saveMovieUIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            _ = try MovieRepository.shared().findOne(by: movie.id!)
            wasSaved = true
            DispatchQueue.main.async(){
                self.saveMovieUIButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.saveMovieUIButton.setTitle("Remover", for: UIControlState.normal)
            }
            
        }catch let error{
            print("Erro ao consultar o banco", error)
        }

        DispatchQueue.main.async() {
            self.titleLabel.text = self.movie.title
            self.averagePointsLabel.text = String(self.movie.vote_average!)
            self.numberOfVotesLabel.text = String(self.movie.vote_count!)
            self.overviewLabel.text = self.movie.overview
        }
        
        if(movie.poster == nil){
            imageDownloadTask = MovieService.shared().getPosterFromAPI(path: self.movie.poster_path!, quality: Quality.high) { image in
                
                self.movie.poster = UIImagePNGRepresentation(image)
                
                DispatchQueue.main.async() {
                    self.posterImageView.image = image
                }
            }
        }else{
            DispatchQueue.main.async() {
                self.posterImageView.image = UIImage(data: self.movie.poster!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(imageDownloadTask != nil){
            imageDownloadTask.cancel()
        }
    }
    
    @IBAction func favoriteMovie(_ sender: Any) {
        if(!wasSaved){
            do{
                try MovieRepository.shared().save(movie: movie)
                self.saveMovieUIButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.saveMovieUIButton.setTitle("Remover", for: UIControlState.normal)
                wasSaved = true
            }catch let error{
                print("Erro ao salvar o filme", error)
            }
        }else{
            do{
                try MovieRepository.shared().remove(id: movie.id!)
                
                self.saveMovieUIButton.backgroundColor = #colorLiteral(red: 1, green: 0.6116010603, blue: 0.006196474039, alpha: 1)
                self.saveMovieUIButton.setTitle("Favoritar", for: UIControlState.normal)
                
                wasSaved = false
            }catch let error{
                print("Erro ao deletar filme", error)
            }
        }
    }
}