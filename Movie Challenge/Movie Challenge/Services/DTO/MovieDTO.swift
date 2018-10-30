//
//  Movie.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

struct Genre : Codable{
    var id: Int?
    var name: String?
    
    init() {
        id = 0
        name = "Genero"
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

struct ProductionCompany : Codable{
    var id: Int?
    var logo_path: String?
    var name: String?
    var origin_country: String?
}

struct ProducionCountry : Codable{
    var iso_3166_1: String?
    var name: String?
}

struct SpokenLanguage : Codable{
    var iso_639_1: String?
    var name: String?
}

struct MovieDTO : Codable{
    var adult: Bool?
    var backdrop_path: String?
    var budget: Int?
    var genres: [Genre]?
    var homepage: String?
    var id: Int?
    private var imdb_id: String?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Float?
    var poster_path: String?
    var production_companies: [ProductionCompany]?
    var production_countries: [ProducionCountry]?
    var release_date: String?
    var revenue: Int?
    var runtime: Int?
    var spoken_languages: [SpokenLanguage]?
    var status: String?
    var tagline: String?
    var title: String?
    var video: Bool?
    var vote_average: Float?
    var vote_count: Int?
    var poster: Data?
    var creation_date: Date?
    var favorite: Bool?
}
