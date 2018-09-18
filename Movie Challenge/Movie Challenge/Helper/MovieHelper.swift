//
//  MovieHelper.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 13/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class MovieHelper{
    
    //MARK:- Movie helpers
    static func movieEntityToDTO(movieEntity: MovieEntity) -> MovieDTO{
        var movieDTO = MovieDTO()
        movieDTO.id = Int(movieEntity.id)
        movieDTO.overview = movieEntity.overview
        movieDTO.poster_path = movieEntity.poster_path
        movieDTO.title = movieEntity.title
        movieDTO.vote_average = movieEntity.vote_average
        movieDTO.vote_count = Int(movieEntity.vote_count)
        movieDTO.poster = movieEntity.poster
        movieDTO.runtime = Int(movieEntity.runtime)
        movieDTO.release_date = movieEntity.release_date
        
        if let categories = movieEntity.categoriesOfMovie{
            movieDTO.genres = categoryEntityListToGenreList(categoryEntityList: Array(categories) as! [CategoryEntity])
        }
        
        return movieDTO
    }
    
    static func movieEntityListToDTOList(movieEntityList: [MovieEntity]) -> [MovieDTO]{
        var movieDTOList = [MovieDTO]()
        
        movieEntityList.forEach{ movieEntity in
            movieDTOList.append(movieEntityToDTO(movieEntity: movieEntity))
        }
        
        return movieDTOList
    }
    
    //MARK:- Category helpers
    static func categoryEntityToGenre(categoryEntity: CategoryEntity) -> Genre{
        let genre = Genre(id: Int(categoryEntity.id), name: categoryEntity.name ?? "Genero")
        
        return genre
    }
    
    static func categoryEntityListToGenreList(categoryEntityList: [CategoryEntity]) -> [Genre]{
        var genreList = [Genre]()
        
        categoryEntityList.forEach{ categoryEntity in
            genreList.append(categoryEntityToGenre(categoryEntity: categoryEntity))
        }
        
        return genreList
    }
    
    static func categoryEntityToDTO(categoryEntity: CategoryEntity) -> CategoryDTO{
        var categoryDTO = CategoryDTO()
        categoryDTO.id = Int(categoryEntity.id)
        categoryDTO.name = categoryEntity.name
        
        let movies = Array(categoryEntity.moviesOfCategory!) as! [MovieEntity]
        
        categoryDTO.movies = movieEntityListToDTOList(movieEntityList: movies)
        
        return categoryDTO
    }
    
    static func categoryEntityListToDTOList(categoryEntityList: [CategoryEntity]) -> [CategoryDTO]{
        var categoryDTOList = [CategoryDTO]()
        
        categoryEntityList.forEach{ categoryEntity in
            categoryDTOList.append(categoryEntityToDTO(categoryEntity: categoryEntity))
        }
        
        return categoryDTOList
    }
}
