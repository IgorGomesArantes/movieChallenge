//
//  NewFavoriteViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 19/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController : UIViewController, MovieViewController{
    
     var viewModel : FavoriteViewModel!
    
    func viewModelStateChange(change: MovieState.Change) {
        selectedCategoryLabel.text = viewModel.selectedCategoryName!
        favoriteMoviesTable.reloadData()
    }
    
    func bindViewModel() {
        viewModel = FavoriteViewModel(onChange: viewModelStateChange)
    }
    
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
        
        bindViewModel()
        
        favoriteMoviesTable.reloadData()
        categoriesCollection.reloadData()
    }
    
    //TODO: Atualizar listas
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewModel()
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
            
                //self.setMovieLists()
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryOptionCollectionViewCell", for: indexPath) as! CategoryOptionCollectionViewCell
        
        let category = viewModel.category(index: indexPath.row)
        
        cell.setUp(name: category.name!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel.selectedCategoryIndex = indexPath.row
        
        print(indexPath.row)
    }
}

//MARK:- Table methods
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMovieTableCell", for: indexPath) as! FavoriteMovieTableViewCell
        
        guard let movies = viewModel.selectedList else { return UITableViewCell() }
        
        cell.setUp(movie: movies[indexPath.row], delegate: self)
        
        return cell
    }
}





