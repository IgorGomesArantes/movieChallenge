//
//  SuggestionCollectionCellViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 09/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class SuggestionCollectionCellViewModel{
    
    //MARK:- Private variables
    private let movie: MovieDTO!
    
    //MARK:- Public variables
    var posterPath: String{
        return AppConstants.BaseImageURL + Quality.low.rawValue + "/" + (movie.poster_path ?? "")
    }
    
    //MARK:- Public methods
    init(movie: MovieDTO){
        self.movie = movie
    }
}
