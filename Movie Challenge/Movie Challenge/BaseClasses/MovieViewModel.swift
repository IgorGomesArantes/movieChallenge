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
    
    var moviePage: MoviePageDTO?
    var movieDetail: MovieDTO?
    
    init(){
        
    }
    
    init(moviePage: MoviePageDTO){
        self.moviePage = moviePage
    }
    
    init(movieDetail: MovieDTO){
        self.movieDetail = movieDetail
    }
}

protocol MovieViewModel{
    var state: MovieState { get }
    var onChange: ((MovieState.Change) -> ()) { get set }
    
    func reload()
    func loadMoreMovies()
    func removeMovieDetail()
    func saveMovieDetail()
    func numberOfRows(section: Int) -> Int
    func numberOfSections() -> Int
    func getMovie() -> MovieDTO
    func getMovie(row: Int) -> MovieDTO
    func getMovie(row: Int, section: Int) -> MovieDTO
}

extension MovieViewModel{
    func loadMoreMovies(){
        
    }
    
    func removeMovieDetail(){
        if let movieDetail = state.movieDetail{
            do{
                try MovieRepository.shared().removeMovie(id: movieDetail.id!)
            }catch let error{
                print("Erro ao deletar o filme", error)
            }
        }else{
            print("O movieDetail não pode ser nulo")
        }
    }
    
    func saveMovieDetail(){
        if let movieDetail = state.movieDetail{
            do{
                try MovieRepository.shared().saveMovie(movie: movieDetail)
            }catch let error{
                print("Erro ao salvar o filme", error)
            }
        }else{
            print("O movieDetail não pode ser nulo")
        }
    }
    
    func numberOfRows(section: Int = 0) -> Int{
        guard let moviePage = state.moviePage else { return 0 }
        
        return moviePage.results.count
    }
    
    func numberOfSections() -> Int{
        return 1
    }
    
    
    func getMovie() -> MovieDTO{
        guard let movieDetail = state.movieDetail else { return MovieDTO() }
        
        return movieDetail
    }
    
    func getMovie(row: Int = -1) -> MovieDTO{
        return (state.moviePage?.results[row])!
    }
    
    //TODO Corrigir
    func getMovie(row: Int = -1, section: Int = -1) -> MovieDTO{
        return state.movieDetail!
    }
}
