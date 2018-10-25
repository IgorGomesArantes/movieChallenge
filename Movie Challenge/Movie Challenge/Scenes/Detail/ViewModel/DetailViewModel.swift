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
    let service: ServiceProtocol
    let repository: RepositoryProtocol
    private(set) var movie: MovieDTO?
    
    //MARK:- Public variables
    private let movieId: Int
    var state: MovieState
    var onChange: ((MovieState.Change) -> ())?
    var onChangeDataBase: ((MovieState.Change) -> ())?
    
    //MARK:- Public methods
    init(movieId: Int, service: ServiceProtocol, repository: RepositoryProtocol){
        state = MovieState()
        
        self.movieId = movieId
        self.service = service
        self.repository = repository
    }
    
    func saveMovieOrRemoveFavorite(){
        if let movie = movie{
            if let favorite = movie.favorite, favorite{
                self.movie!.favorite = false
                remove(movieId: movieId)
            }else{
                self.movie!.favorite = true
                save(movie: movie)
            }
            
            onChangeDataBase!(.success)
        }else{
            onChangeDataBase!(.error)
        }
    }
    
    //MARK:- BaseDetailViewModel
    func numberOfGenres() -> Int {
        guard let movie = self.movie, let genres = movie.genres else { return 0 }
        
        return genres.count
    }
    
    func getGenreViewModel(index: Int) -> GenreViewModel{
        let genreViewModel = GenreViewModel(genre: movie!.genres![index], style: .secondary)
        
        return genreViewModel
    }
    
    //MARK:- MovieViewModel methods
    func reload() {
        do{
            movie = try repository.getMovie(by: movieId)
            movie?.favorite = true
            
            onChange!(MovieState.Change.success)
        }catch{
            service.getMovieDetail(id: movieId){ result in
                switch(result){
                case .success(Success: let movie):
                    self.movie = movie
                    self.movie?.favorite = false
                    
                    self.onChange!(MovieState.Change.success)
                    
                case .error:
                    self.onChange!(MovieState.Change.error)
                }
            }
        }
    }

    //MARK:- DataBaseViewModel methods and variables
    func changeDataBase(change: MovieState.Change) {
        onChangeDataBase!(change)
    }
}
