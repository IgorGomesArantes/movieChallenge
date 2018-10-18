//
//  HomeViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 05/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class HomeViewModel: MovieViewModel, BaseDetailViewModel{
    
    //MARK:- Private variables
    private var moviePageList: [MoviePageDTO]!
    private(set) var movie: MovieDTO?
    
    //MARK:- Public variables
    var state: MovieState
    var onChange: ((MovieState.Change) -> ())?
    
    private func searchMoviePage(sort: Sort, order: Order, label: String, isBestMovieHere: Bool){
        MovieService.shared().getMoviePage(sort: sort, order: order){ result in
            
            switch(result){
            case .success(Success: var moviePage):
                moviePage.label = label
                self.moviePageList.append(moviePage)
                
                if isBestMovieHere{
                    if let bestMovie = moviePage.results.first{
                        MovieService.shared().getMovieDetail(id: bestMovie.id!){ result in
                            switch(result){
                            case .success(Success: let movie):
                                self.movie = movie
                                self.onChange!(.success)
                                
                            case .error:
                                break
                            }
                            
                        }
                    }
                }
                
                self.onChange!(MovieState.Change.success)
                
            case .error:
                break
            }
            

        }
    }
    
    private func searchTrendingMoviePage(label: String){
        MovieService.shared().getTrendingMoviePage(){ result in
            switch(result){
            case .success(Success: var moviePage):
                moviePage.label = label
                self.moviePageList.append(moviePage)
                
                self.onChange!(MovieState.Change.success)
                
            case .error:
                break
            }
        }
    }
    
    private func setMoviePageList(){
        moviePageList = [MoviePageDTO]()
        
        searchMoviePage(sort: Sort.popularity, order: Order.descending, label: "Populares da semana", isBestMovieHere: true)
        searchMoviePage(sort: Sort.voteCount, order: Order.descending, label: "Mais votados de todos os tempos", isBestMovieHere: false)
        searchTrendingMoviePage(label: "Melhores do dia")
    }
    
    //MARK:- Public methods
    init(){
        state = MovieState()
        movie = MovieDTO()
    }
    
    func getSuggestionCellViewModel(index: Int, delegate: SuggestionCellViewModelDelegate) -> SuggestionCellViewModel{
        
        var cellViewModel: SuggestionCellViewModel
        
        switch index{
        case 0:
            cellViewModel = SuggestionCellViewModel(moviePage: moviePageList[index], delegate: delegate, canSearchMore: true, sort: Sort.popularity)
            break
        case 1:
            cellViewModel = SuggestionCellViewModel(moviePage: moviePageList[index], delegate: delegate, canSearchMore: true, sort: Sort.voteCount)
            break
        default:
            cellViewModel = SuggestionCellViewModel(moviePage: moviePageList[index], delegate: delegate, canSearchMore: false)
            break
        }
        
        return cellViewModel
    }
    
    //MARK:- MovieViewModel methods
    func reload() {
        setMoviePageList()
    }
    
    //MARK:- ScrollViewModel methods
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return moviePageList.count
    }
    
    //MARK:- BaseDetailViewModel
    func numberOfGenres() -> Int {
        if(movie!.genres == nil){
            return 0
        }
        
        return movie!.genres!.count
    }
    
    func getGenreViewModel(index: Int) -> GenreViewModel {
        let genreViewModel = GenreViewModel(genre: movie!.genres![index], style: .pattern)
        
        return genreViewModel
    }
}
