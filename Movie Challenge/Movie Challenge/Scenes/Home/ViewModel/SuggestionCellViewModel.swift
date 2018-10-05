//
//  SuggestionCellViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 05/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

//TODO:- BestMovie nao esta setando -> Erro na classe MoreMoviesCell
class SuggestionCellViewModel: MovieViewModel, ScrollViewModel{
    
    //MARK:- Private variables
    private var delegate: SuggestionTableViewCellDelegate
    private(set) var moviePage: MoviePageDTO
    private var getPosterTasks: [URLSessionDataTask]?
    private var page = 2
    private var sort: Sort
    private(set) var canSearchMore: Bool
    
    //MARK:- Public methods
    init(moviePage: MoviePageDTO, delegate: SuggestionTableViewCellDelegate, canSearchMore: Bool, sort: Sort = Sort.popularity){
        self.delegate = delegate
        self.canSearchMore = canSearchMore
        self.sort = sort
        self.moviePage = moviePage
        self.state = MovieState()
    }
    
    func gotoMovieDetail(index: Int){
        if moviePage.results.count > index{
            delegate.changeToMovieDetail(movieId: moviePage.results[index].id!)
        }
    }
    
    //MARK:- MovieViewModel
    var state: MovieState
    
    var onChange: ((MovieState.Change) -> ())?
    
    func reload() {
        onChange!(MovieState.Change.success)
    }
    
    func searchMoreMovies(){
        MovieService.shared().getMoviePage(page: page, sort: sort, order: Order.descending){ newMoviePage, response, error in
            
            self.moviePage.results.append(contentsOf: newMoviePage.results)
            
            self.page += 1
            
            self.onChange!(MovieState.Change.success)
        }
        
    }
    
    //MARK:- ScrollViewModel
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
