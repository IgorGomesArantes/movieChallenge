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
    
    let moviedbAPI = MoviedbAPI()
    var moviePage = MoviePage()
    
    override func viewWillDisappear(_ animated: Bool) {
        moviePage = MoviePage()
        
        DispatchQueue.main.async() {
            self.searchBar.text = ""
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        _ = self.moviedbAPI.getMovies(query: searchBar.text!){ data, response, error in
            
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    self.moviePage = try decoder.decode(MoviePage.self, from: data)
                    print(data)
                    print(self.moviePage)
                    
                    DispatchQueue.main.async() {
                        self.tableView.reloadData()
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedMovie = self.moviePage.results[indexPath.row]
                
                let destinationViewController = segue.destination as! ViewController
                destinationViewController.movie = selectedMovie
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
        
        cell.textLabel?.text = self.moviePage.results[indexPath.row].title
        
        return cell
    }
}
