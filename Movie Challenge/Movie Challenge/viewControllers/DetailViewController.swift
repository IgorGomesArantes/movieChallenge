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
    
    
    private let moviedbAPI: MoviedbAPI = MoviedbAPI()
    public var movie: Movie!
    public var imageDownloadTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async() {
            self.titleLabel.text = self.movie.title
            self.averagePointsLabel.text = String(self.movie.vote_average!)
            self.numberOfVotesLabel.text = String(self.movie.vote_count!)
            self.overviewLabel.text = self.movie.overview
        }
        
        imageDownloadTask = self.moviedbAPI.getPoster(path: self.movie.poster_path!, quality: Quality.high) { data, response, error in

            DispatchQueue.main.sync() {
                self.posterImageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageDownloadTask.cancel()
    }
    
    @IBAction func favoriteMovie(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: context)
        
        movieEntity.setValue(movie.id, forKey: "id")
        movieEntity.setValue(movie.title, forKey: "title")
        movieEntity.setValue(movie.vote_count, forKey: "vote_count")
        movieEntity.setValue(movie.vote_average, forKey: "vote_average")
        movieEntity.setValue(movie.overview, forKey: "overview")
        
        do{
            try context.save()
        }catch{
            print("Erro ao salvar a entidade")
        }
    }
}
