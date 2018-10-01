//
//  SearchViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class SearchViewModel : BaseMovieViewModel{
    var state: MovieListState? = MovieListState(moviePage: MoviePageDTO())
    
    var onChange: ((MovieListState.Change) -> ())?
    
    func loadMoreMovies() {
        return
    }
    
    //MARK:- Public variables
    var searchQuery: String?{
        didSet{
            if let query = searchQuery{
                if query.isEmpty{
                    self.state?.moviePage = MoviePageDTO()
                }else{
                    reloadMovies()
                }
            }
        }
    }
    
    //MARK:- Private methods
    func reloadMovies(){
        guard let query = searchQuery else { return }
        
        MovieService.shared().getMoviePageByName(query: query){ moviePage, reponse, requestError in
            if requestError != nil{
                self.onChange!(MovieListState.Change.error)
            }else{
                self.state?.moviePage = moviePage
                
                self.onChange!(MovieListState.Change.success)
            }
        }
    }
}
