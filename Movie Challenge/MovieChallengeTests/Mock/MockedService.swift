//
//  MockedService.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 17/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
@testable import Movie_Challenge

class MockedService: ServiceProtocol {
    func getMovieDetail(id: Int, completion: (Result<MovieDTO>) -> ()) {
        switch id {
        case 1:
            let deadpool = try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .deadpool))
            completion(.success(deadpool))
            
        case 2:
            let venom = try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .venom))
            completion(.success(venom))
            
        default:
            completion(.error(ServiceError()))
            
        }
    }
    
    func getMoviePage(page: Int, sort: Sort, order: Order, completion: @escaping (Result<MoviePageDTO>) -> ()) {
        
    }
    
    func getMoviePageByName(query: String, completion: @escaping (Result<MoviePageDTO>) -> ()) {
        
    }
    
    func getTrendingMoviePage(page: Int, completion: @escaping (Result<MoviePageDTO>) -> ()) {
        
    }
    
    
}
