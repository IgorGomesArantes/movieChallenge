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
    
    //MARK:- Primitive methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        favoriteMoviesTable.delegate = self
        favoriteMoviesTable.dataSource = self
        
        selectedCategoryLabel.setLittleBorderFeatured()
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

//MARK:- FavoriteMovieTableViewCellDelegate methods
extension FavoriteViewController: FavoriteMovieTableViewCellDelegate{
    func changeToMovieDetail(movieId: Int) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDetailView") as? DetailViewController {
            viewController.setUp(movieId: movieId)
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func removeFavoriteMovie(id: Int) {
        
        let alert = UIAlertController(title: "Deseja mesmo remover este filme dos favoritos?", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: {action in
            do{
                try MovieRepository.shared().removeMovie(id: id)
            
                self.setMovieLists()
            }catch let error{
                print("Não foi possivel remover o filme", error)
            }
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

//MARK:- Collection methods
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categoryList.isEmpty{
            categoriesCollection.showEmptyCell(string: "Ainda não há categorias cadastradas")
            
            return 0
        }
        
        categoriesCollection.hideEmptyCell()
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = categoryList else { return 0 }
        
        return categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryOptionCollectionViewCell", for: indexPath) as! CategoryOptionCollectionViewCell
        
        if indexPath.row == 0{
            cell.setUp(name: "Todos")
        }else{
            guard let categoryName = categoryList[indexPath.row - 1].name else { return UICollectionViewCell() }
            
            cell.setUp(name: categoryName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            selectedCategoryLabel.text = "Todos os filmes"
            selectedList = allMovieList
        }else{
            if let categoryName = categoryList[indexPath.row - 1].name{
                selectedCategoryLabel.text = categoryName
            }
            
            if let movies = categoryList[indexPath.row - 1].movies{
                selectedList = movies
            }else{
                selectedList = [MovieDTO]()
            }
        }
        
        favoriteMoviesTable.reloadData()
    }
}

//MARK:- Table methods
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedList.isEmpty{
            favoriteMoviesTable.showEmptyCell(string: "Ainda não há filmes favoritos")
            
            return 0
        }
        
        favoriteMoviesTable.hideEmptyCell()
        
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





