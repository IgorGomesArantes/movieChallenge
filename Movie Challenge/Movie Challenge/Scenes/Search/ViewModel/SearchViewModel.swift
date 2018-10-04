//
//  SearchViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class SearchViewModel : MovieViewModel, ScrollViewModel{
    
    //MARK:- Private
    private var moviePage: MoviePageDTO!
    
    //MARK:- Public
    var searchQuery: String?{
        didSet{
            reload()
        }
    }
    
    init(onChange: @escaping ((MovieState.Change) -> ())){
        state = MovieState()
        
        self.onChange = onChange
    }
    
    //MARK:- MovieViewModel
    var state: MovieState
    var onChange: ((MovieState.Change) -> ())
    
    func reload(){
        guard let query = searchQuery else { return }
        
        if query.isEmpty{
            self.moviePage = MoviePageDTO()
            state.settedUp = true
            self.onChange(MovieState.Change.emptyResult)
        }else{
            MovieService.shared().getMoviePageByName(query: query){ moviePage, reponse, requestError in
                if requestError != nil{
                    self.moviePage = MoviePageDTO()
                    self.onChange(MovieState.Change.error)
                }else if moviePage.results.isEmpty{
                    self.moviePage = MoviePageDTO()
                    self.state.settedUp = true
                    self.onChange(MovieState.Change.emptyResult)
                }else{
                    self.moviePage = moviePage
                    self.state.settedUp = true
                    self.onChange(MovieState.Change.success)
                }
            }
        }
    }
    
    //MARK:- ScrollViewModel
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int{
        if state.settedUp{
            return moviePage.results.count
        }
        
        return 0
    }
    
    func movie(row: Int, section: Int = 1) -> MovieDTO{
        return moviePage.results[row]
    }
}
