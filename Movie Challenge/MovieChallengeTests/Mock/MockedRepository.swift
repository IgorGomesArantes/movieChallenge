//
//  MockedRepository.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 18/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
@testable import Movie_Challenge

class MockedRepository: RepositoryProtocol{
    
    private var movies: [MovieDTO] = [MovieDTO]()
    private var categories: [CategoryDTO] = [CategoryDTO]()
    
    init(){
        let moviesToSave = try! JSONDecoder().decode([MovieDTO].self, from: MockDataHelper.getData(forResource: .popularList))
        
        for movie in moviesToSave{
            try! saveMovie(movie: movie)
        }
    }
    
    func getAllMovies() throws -> [MovieDTO] {
        return movies
    }
    
    func getMovie(by id: Int) throws -> MovieDTO {
        let filterById = movies.filter{ $0.id == id }
        
        if let movie = filterById.first{
            return movie
        }
        
        throw NotFoundError.runtimeError("Filme nao encontrado")
    }
    
    //TODO:- Colocar essa logica em uma classe separada junto com o MovieRepository
    func saveMovie(movie: MovieDTO) throws {
        do{
            let _ = try getMovie(by: movie.id!)
        }catch{
            movies.append(movie)
            
            if let movieCategories = movie.genres{
                for genre in movieCategories{
                    let filterById = categories.filter{ $0.id == genre.id }
                    if filterById.count == 0 {
                        var category = CategoryDTO()
                        category.id = genre.id
                        category.movies = [MovieDTO]()
                        category.movies?.append(movie)
                        category.name = genre.name
                        categories.append(category)
                    } else if var category = filterById.first {
                        category.movies?.append(movie)
                    }
                }
            }
        }
    }
    
    //TODO:- Colocar essa logica em uma classe separada junto com o MovieRepository
    func removeMovie(id: Int) throws {
        
        let filterById = movies.filter{ $0.id == id }
        
        if filterById.count == 0{
            throw NotFoundError.runtimeError("Filme nao encontrado")
        }
        
        movies = movies.filter { $0.id != id }
        
        for i in 0..<categories.count{
            categories[i].movies = categories[i].movies?.filter{ $0.id != id }
        }
    }
    
    func getAllCategories() throws -> [CategoryDTO] {
        return categories
    }
}
