//
//  MoviePage.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 26/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

struct MoviePageDTO : Codable{
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var label: String?
    var results: [MovieDTO]
    
    init() {
        results = [MovieDTO]()
    }
}
