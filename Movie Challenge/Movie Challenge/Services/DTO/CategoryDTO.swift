//
//  CategoryDTO.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 12/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

struct CategoryDTO : Codable{
    var id: Int?
    var name: String?
    var movies: [MovieDTO]?
}
