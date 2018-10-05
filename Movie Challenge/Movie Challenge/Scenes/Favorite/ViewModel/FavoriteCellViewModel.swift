//
//  FavoriteCellViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 04/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

protocol FavoriteMovieTableViewCellDelegate{
    func removeFavoriteMovie(id: Int)
    func changeToMovieDetail(movieId: Int)
}

class FavoriteCellViewModel: MovieViewModel, BaseDetailViewModel{
    func numberOfGenres() -> Int {
        if state.settedUp{
            guard let genres = movie.genres else { return 0 }
            
            return genres.count
        }
        
        return 0
    }
    
    func getGenre(index: Int) -> Genre{
        guard let genres = movie.genres else { return Genre() }
        
        return genres[index]
    }
    
    private var delegate: FavoriteMovieTableViewCellDelegate!
    var movie: MovieDTO!
    var state: MovieState = MovieState()
    
    var onChange: ((MovieState.Change) -> ())?
    
    func reload() {
        onChange!(MovieState.Change.success)
    }
    
    init(delegate: FavoriteMovieTableViewCellDelegate, movie: MovieDTO){
        self.delegate = delegate
        self.movie = movie
    }
    
    func gotoDetailScene(){
        if let id = movie.id{
            delegate.changeToMovieDetail(movieId: id)
        }
    }
    
    func removeFromFavorite(){
        if let id = movie.id{
            delegate.removeFavoriteMovie(id: id)
        }
    }
}
