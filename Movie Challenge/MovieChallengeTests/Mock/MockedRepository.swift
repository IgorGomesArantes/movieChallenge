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
            movies = try! JSONDecoder().decode([MovieDTO].self, from: MockDataHelper.getData(forResource: .popularList))
            categories = try! JSONDecoder().decode([CategoryDTO].self, from: MockDataHelper.getData(forResource: .popularCategortyList))
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
        let movie =  try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .deadpool))
        
        movies.append(movie)
        
        for genre in movie.genres!{
            var category = CategoryDTO()
            category.id = genre.id
            category.movies?.append(movie)
            category.name = genre.name
            categories.append(category)
        }
    }
    
    //TODO:- Colocar essa logica em uma classe separada junto com o MovieRepository
    func removeMovie(id: Int) throws {
        for _ in movies[0].genres!{
            categories.remove(at: 0)
        }
        
        movies.remove(at: 0)
    }
    
    func getAllCategories() throws -> [CategoryDTO] {
        return categories
    }
}
