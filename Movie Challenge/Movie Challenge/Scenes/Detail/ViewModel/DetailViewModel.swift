//
//  DetailViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 02/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class DetailViewModel: ViewModelProtocol, DataBaseViewModelProtocol, DetailViewModelProtocol {
    
    // MARK: - Private variables
    let service: ServiceProtocol
    let repository: RepositoryProtocol
    private(set) var movie: MovieDTO?
    
    // MARK: - Public variables
    private let movieId: Int
    var onChange: ((MovieState.Change) -> ())?
    var onChangeDataBase: ((MovieState.Change) -> ())?
    
    // MARK: - Public methods
    init(movieId: Int, service: ServiceProtocol, repository: RepositoryProtocol) {
        self.movieId = movieId
        self.service = service
        self.repository = repository
    }
    
    func saveMovieOrRemoveFavorite() {
        if let movie = movie {
            if let favorite = movie.favorite, favorite {
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
    
    // MARK: - BaseDetailViewModel methods
    func numberOfGenres() -> Int {
        guard let movie = self.movie, let genres = movie.genres else { return 0 }
        
        return genres.count
    }
    
    func getGenreViewModel(index: Int) -> GenreViewModel    {
        let genreViewModel = GenreViewModel(genre: movie!.genres![index], style: .secondary)
        
        return genreViewModel
    }
    
    // MARK: - MovieViewModel methods
    func reload() {
        do {
            movie = try repository.getMovie(by: movieId)
            movie?.favorite = true
            
            onChange!(MovieState.Change.success)
        } catch {
            service.getMovieDetail(id: movieId) { response in
                switch(response) {
                case .success(Result: let movie):
                    self.movie = movie
                    self.movie?.favorite = false
                    
                    self.onChange!(.success)
                    
                case .error:
                    self.onChange!(.error)
                }
            }
        }
    }

    // MARK: - DataBaseViewModel methods
    func changeDataBase(change: MovieState.Change) {
        onChangeDataBase!(change)
    }
}
