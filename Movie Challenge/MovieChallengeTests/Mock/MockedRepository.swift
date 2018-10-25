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
    
    enum TestCase{
        case error(Error)
        case savedMovie
        case populatedList
        case none
    }
    
    private var testCase: TestCase
    
    private var movie: MovieDTO?
    private var movies: [MovieDTO] = [MovieDTO]()
    private var categories: [CategoryDTO] = [CategoryDTO]()
    
    private func popule(){
        switch testCase {
        case .populatedList:
            let moviesToSave = try! JSONDecoder().decode([MovieDTO].self, from: MockDataHelper.getData(forResource: .popularList))
            
            for movie in moviesToSave{
                try! saveMovie(movie: movie)
            }
        case .savedMovie:
            movie =  try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .venom))
        case .error:
            break
        case .none:
            break
        }
    }
    
    init(testCase: TestCase){
        self.testCase = testCase
    
        popule()
    }
    
    func getAllMovies() throws -> [MovieDTO] {
        return movies
    }
    
    func getMovie(by id: Int) throws -> MovieDTO {
        switch testCase {
        case .none:
            throw NotFoundError.runtimeError("Filme nao encontrado")
        case .error:
            throw NotFoundError.runtimeError("Filme nao encontrado")
        default:
            return movie ?? MovieDTO()
        }
    }
    
    //TODO:- Colocar essa logica em uma classe separada junto com o MovieRepository
    func saveMovie(movie: MovieDTO) throws {

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
