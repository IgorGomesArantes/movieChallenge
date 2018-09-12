//
//  FavoriteViewController.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 28/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit
import CoreData

class FavoriteViewController : UITableViewController{
    
    var movies : [MovieDTO]!
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            try MovieService.shared().findAllFromDevice(){ savedMovies in
                self.movies = savedMovies
            }
            
            DispatchQueue.main.async(){
                self.tableView.reloadData()
            }
            
        }catch{
            print("Erro ao acessar o banco")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.movies.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieEntityPrototypeCell", for: indexPath)
        
        cell.textLabel?.text = self.movies[indexPath.row].title
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToMovieDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedMovie = self.movies[indexPath.row]
                
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.movie = selectedMovie
                destinationViewController.movieId = selectedMovie.id
            }
        }
    }
}
