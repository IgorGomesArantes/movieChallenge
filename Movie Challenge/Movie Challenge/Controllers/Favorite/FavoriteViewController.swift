//
//  NewFavoriteViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 19/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController : UIViewController{
    
    //MARK:- Private variables
    private var allMovieList: [MovieDTO]!
    private var categoryList: [CategoryDTO]!
    private var selectedList: [MovieDTO]!
    
    //MARK:- View variables
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var favoriteMoviesTable: UITableView!
    @IBOutlet weak var favoriteMoviesView: UIView!
    @IBOutlet weak var selectedCategoryLabel: UILabel!
    
    //MARK:- View actions
    @IBAction func selectAllMovies(_ sender: Any) {
        selectedList = allMovieList
        
        selectedCategoryLabel.text = "Todos os filmes"
        
        favoriteMoviesTable.reloadData()
    }
    
    //MARK:- Primitive methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        favoriteMoviesTable.delegate = self
        favoriteMoviesTable.dataSource = self
        
        favoriteMoviesView.setBorderFeatured()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedCategoryLabel.text = "Todos os filmes"
        
        setMovieLists()
    }
    
    //TODO:- Ordenar no repositorio
    //MARK:- Private methods
    func setMovieLists(){
        do{
            allMovieList = try MovieRepository.shared().getAllMovies()
            categoryList = try MovieRepository.shared().getAllCategories()
            
            categoryList.sort(by: { $0.name! < $1.name! })
            allMovieList.sort(by: { $0.title! < $1.title! })

            if(categoryList.count > 0){
                for i  in 0...categoryList.count - 1{
                    if categoryList[i].movies != nil{
                        categoryList[i].movies?.sort(by: { $0.title! < $1.title! })
                    }
                }
            }
            
            selectedList = allMovieList
            favoriteMoviesTable.reloadData()
            categoriesCollection.reloadData()
        }catch let error{
            print("Erro ao carregar dados: ", error)
        }
    }
}

//MARK:- SendToDetailDegate methods
extension FavoriteViewController: SendToDetailDelegate{
    func changeToMovieDetail(movieId: Int) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDetailView") as? DetailViewController {
            viewController.setUp(movieId: movieId)
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

//MARK:- Collection methods
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = categoryList else { return 0 }
        
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryOptionCollectionViewCell", for: indexPath) as! CategoryOptionCollectionViewCell
        
        guard let categoryName = categoryList[indexPath.row].name else { return UICollectionViewCell() }
        
        cell.setUp(name: categoryName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let categoryName = categoryList[indexPath.row].name{
            selectedCategoryLabel.text = categoryName
        }
        
        if let movies = categoryList[indexPath.row].movies{
            selectedList = movies
        }else{
            selectedList = [MovieDTO]()
        }
        
        favoriteMoviesTable.reloadData()
    }
}

//MARK:- Table methods
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movies = selectedList else { return 0 }
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMovieTableCell", for: indexPath) as! FavoriteMovieTableViewCell
        
        guard let movies = selectedList else { return UITableViewCell() }
        
        cell.setUp(movie: movies[indexPath.row], delegate: self)
        
        return cell
    }
}





