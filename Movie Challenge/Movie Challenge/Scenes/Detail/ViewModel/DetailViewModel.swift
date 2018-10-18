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
    private(set) var movie: MovieDTO?
    let service: ServiceProtocol
    internal let repository: RepositoryProtocol
    
    //MARK:- Public variables
    var state: MovieState
    var onChange: ((MovieState.Change) -> ())?
    private let movieId: Int
    
    //MARK:- Public methods
    init(movieId: Int, service: ServiceProtocol, repository: RepositoryProtocol){
        state = MovieState()
        
        self.movieId = movieId
        self.service = service
        self.repository = repository
    }
    
    func saveMovieOrRemoveFavorite(){
        guard var movie = self.movie else { return }
        if(movie.favorite!){
            movie.favorite = false
            remove(movieId: movieId)
        }else{
            movie.favorite = true
            save(movie: movie)
        }
    }
    
    //MARK:- BaseDetailViewModel
    func numberOfGenres() -> Int {
        guard let movie = self.movie else { return 0 }
        
        return movie.genres!.count
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
    var onChangeDataBase: ((MovieState.Change) -> ())?
    
    func changeDataBase(change: MovieState.Change) {
        onChangeDataBase!(change)
    }
}
