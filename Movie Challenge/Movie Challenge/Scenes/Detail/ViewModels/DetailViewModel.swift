//
//  DetailViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 02/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class DetailViewModel: MovieViewModel{
    
    internal var state: MovieState = MovieState()
    
    var movieId: Int?{
        didSet{
            reload()
        }
    }
    
    var onChange: ((MovieState.Change) -> ())
    
    init(onChange: @escaping ((MovieState.Change) -> ())){
        self.onChange = onChange
    }
    
    func reload() {
        do{
            state.movieDetail = try MovieRepository.shared().getMovie(by: movieId!)
            state.movieDetail?.favorite = true
            
            onChange(MovieState.Change.success)
        }catch{
            MovieService.shared().getMovieDetail(id: movieId!){ movie, response, requestError in
                if requestError != nil{
                    self.onChange(MovieState.Change.error)
                }else{
                    self.state.movieDetail = movie
                    self.state.movieDetail?.favorite = false
                    
                    self.onChange(MovieState.Change.success)
                }
            }
        }
    }
    
    func saveMovieOrRemoveFavorite(){
        
        guard let movieDetail = state.movieDetail else { return }
        guard let favorite = movieDetail.favorite else { return }
        
        if(favorite){
            removeMovieDetail()
            state.movieDetail?.favorite = false
        }else{
            saveMovieDetail()
            state.movieDetail?.favorite = true
        }
    }
}
