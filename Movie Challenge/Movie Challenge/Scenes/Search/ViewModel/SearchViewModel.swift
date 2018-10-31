//
//  SearchViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class SearchViewModel : ViewModelProtocol, ScrollViewModelProtocol {
    
    // MARK: - Private variables
    private var moviePage: MoviePageDTO
    private let service: MovieServiceProtocol
    
    // MARK: - Public variables
    var onChange: ((MovieState.Change) -> ())?
    
    var searchQuery: String {
        didSet {
            reload()
        }
    }
    
    // MARK: - Public Methods
    init(service: MovieServiceProtocol) {
        self.service = service
        searchQuery = ""
        moviePage = MoviePageDTO()
    }
    
    func getSearchCellViewModel(index: Int) -> SearchCellViewModel {
        let cellViewModel = SearchCellViewModel(movie: moviePage.results[index])
        
        return cellViewModel
    }
    
    func getDetailViewModel(index: Int) -> DetailViewModel {
        let movieId = moviePage.results[index].id!
        
        let detailViewModel = DetailViewModel(movieId: movieId, service: HTTPMovieService(), repository: MovieRepository())
        
        return detailViewModel
    }
    
    // MARK: - MovieViewModel methods
    func reload() {
        if searchQuery.isEmpty{
            self.moviePage = MoviePageDTO()
            self.onChange?(MovieState.Change.emptyResult)
        } else {
            service.getMoviePageByName(query: searchQuery) { result in
                switch(result) {
                case .success(Success: let moviePage):
                    if moviePage.results.isEmpty {
                        self.onChange?(MovieState.Change.emptyResult)
                    } else {
                        self.moviePage = moviePage
                        self.onChange?(MovieState.Change.success)
                    }
                case .error:
                    self.moviePage = MoviePageDTO()
                    self.onChange?(MovieState.Change.error)
                }
            }
        }
    }
    
    // MARK: - ScrollViewModel methods
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return moviePage.results.count
    }
}
