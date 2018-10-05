//
//  DetailViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 02/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class DetailViewModel: MovieViewModel, DataBaseViewModel, BaseDetailViewModel{
    
    //MARK:- Private variables
    private(set) var movie: MovieDTO!
    
    //MARK:- Public variables
    var movieId: Int?{
        didSet{
            reload()
        }
    }
    
    //MARK:- Public methods
    init(onChange: @escaping ((MovieState.Change) -> ()), onChangeDataBase: @escaping ((MovieState.Change) -> ())){
        state = MovieState()
        
        self.onChange = onChange
        self.onChangeDataBase = onChangeDataBase
    }
    
    func saveMovieOrRemoveFavorite(){
        
        guard let movie = movie else { return }
        guard let favorite = movie.favorite else { return }
        
        if(favorite){
            self.movie?.favorite = false
            self.remove(movieId: movieId!)
        }else{
            self.movie?.favorite = true
            save(movie: movie)
        }
    }
    
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
    
    //MARK:- MovieViewModel methods and variables
    var state: MovieState
    var onChange: ((MovieState.Change) -> ())?
    
    func reload() {
        do{
            movie = try MovieRepository.shared().getMovie(by: movieId!)
            movie?.favorite = true
            state.settedUp = true
            
            onChange!(MovieState.Change.success)
        }catch{
            MovieService.shared().getMovieDetail(id: movieId!){ movie, response, requestError in
                if requestError != nil{
                    self.onChange!(MovieState.Change.error)
                }else{
                    self.state.settedUp = true
                    self.movie = movie
                    self.movie?.favorite = false
                    
                    self.onChange!(MovieState.Change.success)
                }
            }
        }
    }
    
    //MARK:- DataBaseViewModel methods and variables
    var onChangeDataBase: ((MovieState.Change) -> ())
    
    func changeDataBase(change: MovieState.Change) { 
        onChangeDataBase(change)
    }
}
