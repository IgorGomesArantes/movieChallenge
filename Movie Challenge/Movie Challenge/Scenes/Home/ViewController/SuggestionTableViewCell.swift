//
//  SuggestionTableViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

protocol SuggestionTableViewCellDelegate{
    func changeToMovieDetail(movieId: Int)
}

class SuggestionTableViewCell: UITableViewCell{
    
    //MARK:- Private variables
//    private var delegate: SuggestionTableViewCellDelegate!
//    private var moviePage = MoviePageDTO()
//    private var getPosterTasks: [URLSessionDataTask]!
//    private var page = 2
//    private var sort: Sort!
//    private var canSearchMore: Bool!
    private var viewModel: SuggestionCellViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var categoryLabelView: UILabel!
    @IBOutlet weak var suggestionMoviesCollectionView: UICollectionView!
    @IBOutlet weak var suggestionHeaderView: UIView!
    @IBOutlet weak var suggestionCategoryView: UIView!
    
    
    //MARK:- Primitive variables
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //getPosterTasks = [URLSessionDataTask]()
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
        viewModel.searchMoreMovies()
    }
}

//MARK:- MovieViewController methods
extension SuggestionTableViewCell: MovieViewController{
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
        
        if viewModel.canSearchMore, indexPath.row == viewModel.numberOfRows() - 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreMoviesCollectionViewCell", for: indexPath) as! MoreMoviesCollectionViewCell
            
            cell.setUp(delegate: self)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionMovieCollectionViewCell", for: indexPath) as! SuggestionCollectionViewCell
            
            cell.setup(movie: viewModel.movie(row: indexPath.row))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.gotoMovieDetail(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        print("Teste: " + String(indexPath.row))
        
        return true
    }
}
