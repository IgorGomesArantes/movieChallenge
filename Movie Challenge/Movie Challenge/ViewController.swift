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
    
    private let moviedbAPI: MoviedbAPI = MoviedbAPI()
    private var movie: Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviedbAPI.getMovie(id: 102){ data, response, error in
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.movie = try decoder.decode(Movie.self, from: data)
                
                    DispatchQueue.main.async() {
                        self.titleText.text = self.movie.title
                    }
                    
                    self.moviedbAPI.getPoster(path: self.movie.poster_path!, quality: Quality.high) { data, response, error in

                        DispatchQueue.main.async() {
                            self.imageView.image = UIImage(data: data!)
                            self.imageView.setNeedsLayout()
                        }
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
    }
}



