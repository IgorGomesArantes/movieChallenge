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
    var onChange: ((MovieState.Change) -> ())? { get set }
    func reload()
}

protocol DataBaseViewModel{
    var onChangeDataBase: ((MovieState.Change) -> ()) { get set }
    func remove(movieId: Int)
    func save(movie: MovieDTO)
    func changeDataBase(change: MovieState.Change)
}

extension DataBaseViewModel{
    func remove(movieId: Int){
        do{
            try MovieRepository.shared().removeMovie(id: movieId)
            self.changeDataBase(change: MovieState.Change.success)
        }catch let error{
            print("Erro ao remover: ", error)
            self.changeDataBase(change: MovieState.Change.error)
        }
    }
    
    func save( movie: MovieDTO){
        do{
            try MovieRepository.shared().saveMovie(movie: movie)
            self.changeDataBase(change: MovieState.Change.success)
        }catch let error{
            print("Erro ao salvar: ", error)
            self.changeDataBase(change: MovieState.Change.error)
        }
    }
}

protocol ScrollViewModel{
    func numberOfSections() -> Int
    func numberOfRows() -> Int
    func movie(row: Int, section: Int) -> MovieDTO
}

protocol BaseDetailViewModel{
    func numberOfGenres() -> Int
    func getGenre(index: Int) -> Genre
}
