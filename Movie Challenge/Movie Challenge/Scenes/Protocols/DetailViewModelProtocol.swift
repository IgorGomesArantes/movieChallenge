//
//  BaseDetailViewModelProtocol.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 30/10/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

protocol DetailViewModelProtocol {
    var movie: MovieDTO? { get }
    
    func numberOfGenres() -> Int
    func getGenreViewModel(index: Int) -> GenreViewModel
    var year: String { get }
    var title: String { get }
    var runtime: String { get }
    var overview: String { get }
    var voteCount: String { get }
    var posterPath: String { get }
    var voteAverage: String { get }
    var creationDate: String { get }
}

extension DetailViewModelProtocol {
    
    var posterPath:  String {
        guard let movie = movie, let path = movie.poster_path else { return NSLocalizedString("Empty poster path", comment: "") }
        
        return AppConstants.BaseImageURL + Quality.high.rawValue + path
    }
    
    var title: String {
        guard let movie = movie else { return NSLocalizedString("Unknown title", comment: "") }
        
        return movie.title ?? NSLocalizedString("Unknown title", comment: "")
    }
    
    var voteAverage: String {
        guard let movie = movie, let average = movie.vote_average else { return NSLocalizedString("Empty vote average", comment: "") }
        
        return String(average)
    }
    
    var voteCount: String {
        guard let movie = movie, let count = movie.vote_count else { return NSLocalizedString("Empty vote count", comment: "") }
        
        return "(" + String(count) + ")"
    }
    
    var overview: String {
        guard let movie = movie else { return NSLocalizedString("Empty overview", comment: "") }
        
        return movie.overview ?? NSLocalizedString("Empty overview", comment: "")
    }
    
    var year: String {
        guard let movie = movie, let releaseDate = movie.release_date else { return NSLocalizedString("Empty year", comment: "") }
        
        if !releaseDate.isEmpty {
            return String((releaseDate.split(separator: "-").first)!)
        }
        
        return NSLocalizedString("Empty year", comment: "")
    }
    
    var runtime: String {
        guard let movie = movie, let runtime = movie.runtime else { return NSLocalizedString("Empty runtime", comment: "") }
        
        return String(runtime / 60) + "h" + String(runtime % 60) + "m"
    }
    
    var creationDate: String {
        guard let movie = movie else { return NSLocalizedString("Empty creation date", comment: "") }
        
        return movie.creation_date != nil ? (movie.creation_date?.toString(dateFormat: "dd-MM-yyyy"))! : NSLocalizedString("Empty creation date", comment: "")
    }
}
