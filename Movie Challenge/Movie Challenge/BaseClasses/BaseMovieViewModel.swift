//
//  BaseMovieViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

struct MovieListState{
    enum Change{
        case success
        case error
    }
    
    var moviePage: MoviePageDTO
}

protocol BaseMovieViewModel{
    var state: MovieListState? { get }
    var onChange: ((MovieListState.Change) -> ())? { get set }
    
    func reloadMovies()
    func loadMoreMovies()
}
