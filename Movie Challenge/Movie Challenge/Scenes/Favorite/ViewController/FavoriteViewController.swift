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

    //Private variables
    private var viewModel : FavoriteViewModel!

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reload()
    }
}

//MARK:- FavoriteMovieTableViewCellDelegate methods
extension FavoriteViewController: FavoriteCellViewModelDelegate{
    func changeToMovieDetail(movieId: Int) {
        if let viewController = UIStoryboard(name: AppConstants.storyBoardName, bundle: nil).instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController {
            viewController.setup(viewModel: viewModel.getDetailViewModel(movieId: movieId))
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func removeFavoriteMovie(id: Int) {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {action in
            self.viewModel.remove(movieId: id)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

//MARK:- MovieViewController methods
extension FavoriteViewController: MovieViewController{
    func viewModelStateChange(change: MovieState.Change) {
        
        favoriteMoviesTable.reloadData()
        categoriesCollection.reloadData()
        
        selectedCategoryLabel.text = viewModel.selectedCategoryName
        
        switch change {
        case .success:
            favoriteMoviesTable.hideEmptyCell()
            categoriesCollection.hideEmptyCell()
            break
        case .emptyResult:
            favoriteMoviesTable.showEmptyCell(string: NSLocalizedString("Empty favorites", comment: ""))
            categoriesCollection.showEmptyCell(string: NSLocalizedString("Empty categories", comment: ""))
            break
        default:
            break
        }
    }
    
    func bindViewModel() {
        self.viewModel = FavoriteViewModel(repository: MovieRepository(), onChange: viewModelStateChange, onChangeDataBase: viewModelDataBaseChange)
    }
}

//Mark:- DataBaseController methods
extension FavoriteViewController: DataBaseViewController{
    func viewModelDataBaseChange(change: MovieState.Change) {
        switch change {
        case .success:
            selectedCategoryLabel.text = viewModel.selectedCategoryName
            favoriteMoviesTable.reloadData()
            categoriesCollection.reloadData()
            break
        case .error:
            showAlert(title: NSLocalizedString("DataBaseAccessError", comment: ""))
            break
        default:
            break
        }
    }
}

//MARK:- Collection methods
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryOptionCollectionViewCell.identifier, for: indexPath) as! CategoryOptionCollectionViewCell
        
        cell.setup(viewModel: viewModel.getCategoryOptionViewModel(index: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCategoryIndex = indexPath.row
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMovieTableViewCell.identifier, for: indexPath) as! FavoriteMovieTableViewCell

        cell.setup(viewModel: viewModel.getFavoriteCellViewModel(delegate: self, index: indexPath.row))
        
        return cell
    }
}





