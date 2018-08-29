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
    
    var movies : [MovieEntity]!
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            movies = try MovieRepository.shared().findAll()

            DispatchQueue.main.async(){
                self.tableView.reloadData()
            }

            print(movies.count)
            
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
                
                var movieDTO = MovieDTO()
                movieDTO.title = selectedMovie.title
                movieDTO.overview = selectedMovie.overview
                movieDTO.id = Int(selectedMovie.id)
                movieDTO.vote_average = selectedMovie.vote_average
                movieDTO.vote_count = Int(selectedMovie.vote_count)
                movieDTO.poster_path = selectedMovie.poster_path
                
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.movie = movieDTO
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        do{
//            try MovieRepository.shared().remove(movieEntity: movies[indexPath.row])
//
//            movies.remove(at: indexPath.row)
//
//            DispatchQueue.main.async() {
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        }catch{
//            print("Erro ao deletar filme")
//        }
//    }
}
