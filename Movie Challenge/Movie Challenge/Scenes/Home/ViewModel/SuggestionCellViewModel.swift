//
//  SuggestionCellViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 05/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

protocol SuggestionCellViewModelDelegate{
    func changeToMovieDetail(movieId: Int)
}

class SuggestionCellViewModel: ViewModelProtocol, ScrollViewModelProtocol {
    
    // MARK: - Private variables
    private var page = 2
    private var sort: Sort
    private var getPosterTasks: [URLSessionDataTask]?
    private var delegate: SuggestionCellViewModelDelegate

    private(set) var canSearchMore: Bool
    private(set) var moviePage: MoviePageDTO
    
    // MARK: - Public variables
    var state: MovieState
    var service: MovieServiceProtocol
    var onChange: ((MovieState.Change) -> ())?
    
    // MARK: - Public methods
    init(service: MovieServiceProtocol, moviePage: MoviePageDTO, delegate: SuggestionCellViewModelDelegate, canSearchMore: Bool, sort: Sort = Sort.popularity) {
        self.sort = sort
        self.service = service
        self.delegate = delegate
        self.state = MovieState()
        self.moviePage = moviePage
        self.canSearchMore = canSearchMore
    }
    
    func gotoMovieDetail(index: Int) {
        if moviePage.results.count > index{
            delegate.changeToMovieDetail(movieId: moviePage.results[index].id!)
        }
    }
    
    func getSuggestionCollectionCellViewModel(index: Int) -> SuggestionCollectionCellViewModel {
        return SuggestionCollectionCellViewModel(movie: moviePage.results[index])
    }
    
    func getMoreMoviesCollectionCellViewModel(delegate: MoreMoviesCollectionViewCellDelegate) -> MoreMoviesCollectionCellViewModel{
        return MoreMoviesCollectionCellViewModel(delegate: delegate)
    }
    
    func isThisTheMoreMoviesCellTime(index: Int) -> Bool {
        if canSearchMore, index == numberOfRows() - 1{
            return true
        }else{
            return false
        }
    }
    
    // MARK: - MovieViewModel
    func reload() {
        onChange!(MovieState.Change.success)
    }
    
    func searchMoreMovies(completion: @escaping () -> ()){
        service.getMoviePage(page: page, sort: sort, order: Order.descending) { result in
            switch(result){
            case .success(Success: let newMoviePage):
                self.moviePage.results.append(contentsOf: newMoviePage.results)
                
                self.page += 1
                
                self.onChange!(MovieState.Change.success)
                
                completion()
            case .error:
                break
            }
        }
    }
    
    // MARK: - ScrollViewModel
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        if canSearchMore{
            return moviePage.results.count + 1
        }
        
        return moviePage.results.count
    }
    
    func movie(row: Int, section: Int = 1) -> MovieDTO {
        return moviePage.results[row]
    }
}
