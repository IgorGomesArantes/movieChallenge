//
//  GenreViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 08/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

enum GenreStyle: Int{
    case pattern = 1
    case secondary = 2
}

class GenreViewModel{
    
    let genre: Genre
    let style: GenreStyle
    
    init(genre: Genre, style : GenreStyle){
        self.genre = genre
        self.style = style
    }
}
