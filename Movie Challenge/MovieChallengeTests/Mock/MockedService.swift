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
    
    enum TestCaseDetail {
        case error(Error)
        case savedMovie
        case newMovie
    }
    
    enum TestCasePage {
        case error(Error)
        case populatedPage
        case emptyPage
    }
    
    var testCaseDetail: TestCaseDetail?
    var testCasePage: TestCasePage?
    
    init(testCaseDetail: TestCaseDetail) {
        self.testCaseDetail = testCaseDetail
    }
    
    init(testCasePage: TestCasePage){
        self.testCasePage = testCasePage
    }
    
    func getMovieDetail(id: Int, completion: (Result<MovieDTO>) -> ()) {
        switch testCaseDetail {
        case .error(let error)?:
            completion(.error(error))
        case .newMovie?:
            let deadpool = try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .deadpool))
            completion(.success(deadpool))
        case .savedMovie?:
            completion(.error(ServiceError()))
        case .none:
            break
        }
    }
    
    func getMoviePage(page: Int, sort: Sort, order: Order, completion: @escaping (Result<MoviePageDTO>) -> ()) {
        
    }
    
    func getMoviePageByName(query: String, completion: @escaping (Result<MoviePageDTO>) -> ()) {
        switch testCasePage {
        case .error(let error)?:
            completion(.error(error))
        case .populatedPage?:
            let moviePage = try! JSONDecoder().decode(MoviePageDTO.self, from: MockDataHelper.getData(forResource: .popularPage))
            completion(.success(moviePage))
        case .emptyPage?:
            completion(.success(MoviePageDTO()))
        case .none:
            break
        }
    }
    
    func getTrendingMoviePage(page: Int, completion: @escaping (Result<MoviePageDTO>) -> ()) {
        
    }
    
    
}
