//
//  SearchViewController.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 26/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var moviePage = MoviePageDTO()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            self.moviePage = MoviePageDTO()
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
        }
        else{
            _ = MovieService.shared().getMoviePageByName(query: searchText){ newMoviePage, response, error in
                self.moviePage = newMoviePage
                
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToMovieDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedMovie = self.moviePage.results[indexPath.row]
                
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.movie = selectedMovie
                destinationViewController.movieId = selectedMovie.id
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.moviePage.results.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviePrototypeCell", for: indexPath)
        
        if(indexPath.row < moviePage.results.count){
            cell.textLabel?.text = self.moviePage.results[indexPath.row].title
        }

        return cell
    }
}
