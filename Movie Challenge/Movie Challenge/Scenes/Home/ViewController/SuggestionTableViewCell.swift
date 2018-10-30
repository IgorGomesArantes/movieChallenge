//
//  SuggestionTableViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

//TODO:- Tratar os erros de viewModelStateChange 
class SuggestionTableViewCell: UITableViewCell{
    
    //MARK:- Constants
    static let identifier = "suggestionTableViewCell"
    
    //MARK:- Private variables
    private var viewModel: SuggestionCellViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var categoryLabelView: UILabel!
    @IBOutlet weak var suggestionMoviesCollectionView: UICollectionView!
    @IBOutlet weak var suggestionHeaderView: UIView!
    @IBOutlet weak var suggestionCategoryView: UIView!
    
    //MARK:- Primitive variables
    override func awakeFromNib() {
        super.awakeFromNib()
        
        suggestionCategoryView.setCornerRadius()
        
        suggestionMoviesCollectionView.setLittleBorderFeatured()
        suggestionCategoryView.setLittleBorderFeatured()
    }
    
    //MARK:- Public methods
    func setup(viewModel: SuggestionCellViewModel){
        suggestionMoviesCollectionView.delegate = self
        suggestionMoviesCollectionView.dataSource = self
        
        self.viewModel = viewModel
        bindViewModel()
        viewModel.reload()
    }
}

//MARK:- MoreMoviesCollectionViewCellDelegate methods
extension SuggestionTableViewCell: MoreMoviesCollectionViewCellDelegate{
    func searchMoreMovies(completion: @escaping () -> ()) {
        viewModel.searchMoreMovies(){
            completion()
        }
    }
}

//MARK:- MovieViewController methods
extension SuggestionTableViewCell: ViewControllerProtocol{
    func viewModelStateChange(change: MovieState.Change) {
        switch change {
        case .success:
            categoryLabelView.text = viewModel.moviePage.label
            self.suggestionMoviesCollectionView.reloadData()
            break
        default:
            break
        }
    }
    
    func bindViewModel() {
        viewModel.onChange = viewModelStateChange
    }
}

//MARK: Collection view methods
extension SuggestionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel.isThisTheMoreMoviesCellTime(index: indexPath.row){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreMoviesCollectionViewCell.identifier, for: indexPath) as! MoreMoviesCollectionViewCell
            
            cell.setup(viewModel: viewModel.getMoreMoviesCollectionCellViewModel(delegate: self))
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionViewCell.identifier, for: indexPath) as! SuggestionCollectionViewCell
            
            cell.setup(viewModel: viewModel.getSuggestionCollectionCellViewModel(index: indexPath.row))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.gotoMovieDetail(index: indexPath.row)
    }
}
