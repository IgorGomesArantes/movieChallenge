//
//  SearchViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class SearchViewModel : MovieViewModel, ScrollViewModel{
    
    //MARK:- Private variables
    private var moviePage: MoviePageDTO
    
    //MARK:- Public variables
    var state: MovieState
    var onChange: ((MovieState.Change) -> ())?
    
    var searchQuery: String{
        didSet{
            reload()
        }
    }
    
    //MARK:- Public Methods
    init(){
        searchQuery = ""
        state = MovieState()
        moviePage = MoviePageDTO()
    }
    
    func getSearchCellViewModel(index: Int) -> SearchCellViewModel{
        let cellViewModel = SearchCellViewModel(movie: moviePage.results[index])
        
        return cellViewModel
    }
    
    func getDetailViewModel(index: Int) -> DetailViewModel{
        let movieId = moviePage.results[index].id!
        
        let detailViewModel = DetailViewModel(movieId: movieId, service: MovieService(), repository: MovieRepository())
        
        return detailViewModel
    }
    
    //MARK:- MovieViewModel methods
    func reload(){
        if searchQuery.isEmpty{
            self.moviePage = MoviePageDTO()
            self.onChange!(MovieState.Change.emptyResult)
        }else{
            MovieService.shared().getMoviePageByName(query: searchQuery){ result in
                switch(result){
                case .success(Success: let moviePage):
                    if moviePage.results.isEmpty{
                        self.moviePage = MoviePageDTO()
                        self.onChange!(MovieState.Change.emptyResult)
                    }else{
                        self.moviePage = moviePage
                        self.onChange!(MovieState.Change.success)
                    }
                case .error:
                    self.moviePage = MoviePageDTO()
                    self.onChange!(MovieState.Change.error)
                }
            }
        }
    }
    
    //MARK:- ScrollViewModel methods
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int{
        return moviePage.results.count
    }
}
