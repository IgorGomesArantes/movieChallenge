//
//  FavoriteCellViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 04/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

protocol FavoriteCellViewModelDelegate{
    func removeFavoriteMovie(id: Int)
    func changeToMovieDetail(movieId: Int)
}

class FavoriteCellViewModel: ViewModelProtocol, DetailViewModelProtocol{
    
    //MARK:- Private variables
    private var delegate: FavoriteCellViewModelDelegate!
    private(set) var movie: MovieDTO?
    private(set) var state: MovieState = MovieState()
    var progressBarScore: Float{
        return movie!.vote_average != nil ? movie!.vote_average! / 10.0 : 0.0
    }
    
    //MARK: Public variables
    var onChange: ((MovieState.Change) -> ())?
    
    //MARK:- Public methods
    init(delegate: FavoriteCellViewModelDelegate, movie: MovieDTO){
        self.delegate = delegate
        self.movie = movie
    }
    
    func gotoDetailScene(){
        if let id = movie!.id{
            delegate.changeToMovieDetail(movieId: id)
        }
    }
    
    func removeFromFavorite(){
        if let id = movie!.id{
            delegate.removeFavoriteMovie(id: id)
        }
    }
    
    //MARK:- MovieViewModel methods
    func reload() {
        onChange!(MovieState.Change.success)
    }
    
    //MARK:- BaseDetailViewModel methods
    func numberOfGenres() -> Int {
        guard let genres = movie!.genres else { return 0 }
        
        return genres.count
    }
    
    func getGenreViewModel(index: Int) -> GenreViewModel {
        let genreViewModel = GenreViewModel(genre: movie!.genres![index], style: .pattern)
        
        return genreViewModel
    }
}
