//
//  SearchViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class SearchViewModel : MovieViewModel{

    var state: MovieState = MovieState(moviePage: MoviePageDTO())
    
    var onChange: ((MovieState.Change) -> ())
    
    init(onChange: @escaping ((MovieState.Change) -> ())){
        self.onChange = onChange
    }
    
    //MARK:- Public variables
    var searchQuery: String?{
        didSet{
            reload()
        }
    }
    
    //MARK:- Private methods
    func reload(){
        guard let query = searchQuery else { return }
        
        if query.isEmpty{
            self.state.moviePage = MoviePageDTO()
            self.onChange(MovieState.Change.emptyResult)
        }else{
            MovieService.shared().getMoviePageByName(query: query){ moviePage, reponse, requestError in
                if requestError != nil{
                    self.state.moviePage = MoviePageDTO()
                    self.onChange(MovieState.Change.error)
                }else if moviePage.results.isEmpty{
                    self.state.moviePage = MoviePageDTO()
                    self.onChange(MovieState.Change.emptyResult)
                }else{
                    self.state.moviePage = moviePage
                    self.onChange(MovieState.Change.success)
                }
            }
        }
    }
}
