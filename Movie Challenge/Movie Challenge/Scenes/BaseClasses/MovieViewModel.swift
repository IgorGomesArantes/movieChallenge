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
    var onChangeDataBase: ((MovieState.Change) -> ())? { get set }
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
    //func movie(row: Int, section: Int) -> MovieDTO
}

protocol BaseDetailViewModel{
    var movie: MovieDTO! { get }
    
    func numberOfGenres() -> Int
    func getGenreViewModel(index: Int) -> GenreViewModel
    var posterPath: String { get }
    var title: String { get }
    var voteCount: String { get }
    var voteAverage: String { get }
    var overview: String { get }
    var year: String { get }
    var runtime: String { get }
}

extension BaseDetailViewModel{
    
    var posterPath:  String{
        return movie.poster_path ?? ""
    }
    
    var title: String{
        return movie.title ?? "Titulo desconhecido"
    }
    
    var voteAverage: String{
        guard let average = movie.vote_average else { return "0" }
        
        return String(average)
    }
    
    var voteCount: String{
        guard let count = movie.vote_count else { return "(0)" }
        
        return "(" + String(count) + ")"
    }
    
    
    var overview: String{
        return movie.overview ?? "Não há resumo"
    }
    
    var year: String{
        guard let releaseDate = movie.release_date else { return "0000" }
        
        if !releaseDate.isEmpty{
            return String((releaseDate.split(separator: "-").first)!)
        }
        
        return "0000"
    }
    
    var runtime: String{
        guard let runtime = movie.runtime else { return "00h 00m" }
        
        return String(runtime / 60) + "h" + String(runtime % 60) + "m"
    }
}
