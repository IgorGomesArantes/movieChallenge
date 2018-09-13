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
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    private var wasSaved = false
    
    public var movie: MovieDTO!
    public var movieId: Int!
    public var imageDownloadTask: URLSessionDataTask!
    @IBOutlet weak var saveMovieUIButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoading()
        
        do{
            let movie = try MovieRepository.shared().getOne(by: movieId)
            
            self.wasSaved = true
            
            DispatchQueue.main.async(){
                self.saveMovieUIButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.saveMovieUIButton.setTitle("Remover", for: UIControlState.normal)
            }
            
            self.fillFields(with: movie)
            
        }catch let notFoundError{
            print("Error", notFoundError)
        }
        
        if(!wasSaved){
            _ = MovieService.shared().getMovieDetail(id: movieId){ movie, response, error in
                self.fillFields(with: movie)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(imageDownloadTask != nil){
            imageDownloadTask.cancel()
        }
        stopLoading()
    }
    
    //TODO Corrigir quando campos vem vazios
    func fillFields(with movie: MovieDTO){
        self.movie = movie
        
        DispatchQueue.main.async() {
            self.titleLabel.text = self.movie.title
            self.averagePointsLabel.text = String(self.movie.vote_average!)
            self.numberOfVotesLabel.text = String(self.movie.vote_count!)
            self.overviewLabel.text = self.movie.overview
            
            if let releaseDate = self.movie.release_date{
                self.yearLabel.text = String(releaseDate.split(separator: "-").first!)
            }else{
                self.yearLabel.text = self.movie.release_date
            }
            //self.durationLabel.text = String(self.movie.runtime!) ?? "0" + " min"
        }
        
        if(movie.poster == nil){
            if(movie.poster_path != nil){
                
                imageDownloadTask = MovieService.shared().getPoster(path: self.movie.poster_path!, quality: Quality.high) { image, response, error in
                    
                    self.movie.poster = UIImagePNGRepresentation(image)
                    
                    DispatchQueue.main.async() {
                        self.posterImageView.image = image
                        self.posterImageView.setNeedsDisplay()
                        self.stopLoading()
                    }

                }
            } else{
                DispatchQueue.main.async() {
                    self.posterImageView.image = UIImage(named: "placeholder-image")
                    self.posterImageView.setNeedsDisplay()
                    self.stopLoading()
                }
            }
        }else{
            DispatchQueue.main.async() {
                self.posterImageView.image = UIImage(data: self.movie.poster!)
                self.posterImageView.setNeedsDisplay()
                self.stopLoading()
            }
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
    
    func startLoading(){
        let alert = UIAlertController(title: nil, message: "Aguarde os dados...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: {
            if(self.posterImageView != nil){
                self.stopLoading()
            }
        })
    }
    
    func stopLoading(){
        dismiss(animated: true, completion: nil)
    }
}
