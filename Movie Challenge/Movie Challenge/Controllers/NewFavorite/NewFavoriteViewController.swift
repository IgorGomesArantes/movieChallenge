//
//  NewFavoriteViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 19/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class NewFavoriteViewController : UIViewController{
    
    //MARK:- View variables
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var favoriteMoviesTable: UITableView!
    
    //MARK:- View actions
    @IBAction func selectAllMovies(_ sender: Any) {
        print("Clicou")
    }
    
    //MARK:- Primitive methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        favoriteMoviesTable.delegate = self
        favoriteMoviesTable.dataSource = self
    }
}

//MARK:- Collection methods
extension NewFavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCategoryCollectionCell", for: indexPath)
        
        return cell
    }
}

//MARK:- Table methods
extension NewFavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMovieTableCell", for: indexPath) as! favoriteMovieTableViewCell
        
        return cell
    }
    
    
}





