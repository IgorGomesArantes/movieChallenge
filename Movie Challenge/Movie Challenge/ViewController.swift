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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moviedbAPI: MoviedbAPI = MoviedbAPI()
        
        
        //moviedbAPI.getDataFromUrl(url: <#T##URL#>, completion: <#T##(Data?, URLResponse?, Error?) -> ()#>)
        
        let movie = moviedbAPI.getMovie()
        
        
    
        moviedbAPI.getPoster(path: "kqjL17yufvn9OVLyXYpvtyrFfak.jpg", quality: Quality.high) { data, response, error in

            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data!)
                self.imageView.setNeedsLayout()
            }
        }
        
//        let url = URL(string: moviedbAPI.imageBaseURL + "/" + Quality.high.rawValue + "/" + "kqjL17yufvn9OVLyXYpvtyrFfak.jpg")
//
//        moviedbAPI.getDataFromUrl(url: url!) { data, response, error in
//
//
//            DispatchQueue.main.async() {
//                self.imageView.image = UIImage(data: data!)
//                self.imageView.setNeedsLayout()
//            }
//        }
        
        //imageView.image = moviedbAPI.getPoster(path: movie.poster_path, quality: Quality.high)
        //self.imageView.setNeedsLayout()
        
        self.titleText.text = movie.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



