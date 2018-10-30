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
    
    enum TestCase {
        case error(Error)
        case newMovie
        case populatedPage
        case emptyPage
        case none
    }
    
    var testCase: TestCase?
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    
    func getMovieDetail(id: Int, completion: (Response<MovieDTO>) -> ()) {
        switch testCase {
        case .error(let error)?:
            completion(.error(error))
        case .newMovie?:
            let deadpool = try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .deadpool))
            completion(.success(deadpool))
        default:
            completion(.error(ServiceError()))
        }
    }
    
    func getMoviePage(page: Int, sort: Sort, order: Order, completion: @escaping (Response<MoviePageDTO>) -> ()) {
        
    }
    
    func getMoviePageByName(query: String, completion: @escaping (Response<MoviePageDTO>) -> ()) {
        switch testCase {
        case .error(let error)?:
            completion(.error(error))
        case .populatedPage?:
            let moviePage = try! JSONDecoder().decode(MoviePageDTO.self, from: MockDataHelper.getData(forResource: .popularPage))
            completion(.success(moviePage))
        case .emptyPage?:
            completion(.success(MoviePageDTO()))
        default:
            completion(.error(ServiceError()))
        }
    }
    
    func getTrendingMoviePage(page: Int, completion: @escaping (Response<MoviePageDTO>) -> ()) {
        
    }
}
