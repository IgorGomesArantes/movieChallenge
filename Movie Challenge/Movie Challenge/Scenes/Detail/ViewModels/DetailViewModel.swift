//
//  DetailViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 02/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class DetailViewModel: MovieViewModel, FavoriteViewModel{
    
    var state: MovieState = MovieState()
    var movie: MovieDTO!
    
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
            movie = try MovieRepository.shared().getMovie(by: movieId!)
            movie?.favorite = true
            state.settedUp = true
            
            onChange(MovieState.Change.success)
        }catch{
            MovieService.shared().getMovieDetail(id: movieId!){ movie, response, requestError in
                if requestError != nil{
                    self.onChange(MovieState.Change.error)
                }else{
                    self.state.settedUp = true
                    self.movie = movie
                    self.movie?.favorite = false
                    
                    self.onChange(MovieState.Change.success)
                }
            }
        }
    }
    
    private func save(){
        if let movie = movie{
            do{
                try MovieRepository.shared().saveMovie(movie: movie)
            }catch let error{
                print("Erro ao salvar o filme", error)
            }
        }else{
            print("O filme não pode ser nulo")
        }
    }
    
    func saveMovieOrRemoveFavorite(){
        
        guard let movie = movie else { return }
        guard let favorite = movie.favorite else { return }
        
        if(favorite){
            self.remove(movieId: movieId!)
            self.movie?.favorite = false
        }else{
            save()
            self.movie?.favorite = true
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
}
