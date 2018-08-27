//
//  ViewController.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var averagePoints: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    
    private let moviedbAPI: MoviedbAPI = MoviedbAPI()
    public var movie: Movie!
    public var imageDownloadTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async() {
            self.titleText.text = self.movie.title
            self.averagePoints.text = String(self.movie.vote_average!)
            self.overviewText.text = self.movie.overview
        }
        
        imageDownloadTask = self.moviedbAPI.getPoster(path: self.movie.poster_path!, quality: Quality.high) { data, response, error in
            
            DispatchQueue.main.sync() {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageDownloadTask.cancel()
    }
}
