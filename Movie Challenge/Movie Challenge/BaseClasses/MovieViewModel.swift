//
//  BaseMovieViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

struct MovieState{
    enum Change{
        case success
        case error
        case emptyResult
    }
    
    var settedUp: Bool = false
}

protocol MovieViewModel{
    var state: MovieState { get }
    var onChange: ((MovieState.Change) -> ()) { get set }
    func reload()
}

protocol FavoriteViewModel{
    func remove(movieId: Int)
}

extension FavoriteViewModel{
    func remove(movieId: Int){
        do{
            try MovieRepository.shared().removeMovie(id: movieId)
        }catch let error{
            print("Erro ao deletar o filme", error)
        }
    }
}

protocol ScrollViewModel{
    func numberOfSections() -> Int
    func numberOfRows() -> Int
    func movie(row: Int, section: Int) -> MovieDTO
}
