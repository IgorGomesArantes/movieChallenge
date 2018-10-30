//
//  SearchCellViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 30/10/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class SearchCellViewModelTests: XCTestCase {
    
    // MARK: - Private variables
    private var sut: SearchCellViewModel!
    
    // MARK: - Primitive methods
    override func setUp() {
        let deadpool = try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .deadpool))
        
        sut = SearchCellViewModel(movie: deadpool)
    }
    
    // MARK: - Test methods
    func testPosterPath() {
        // Then
        XCTAssertEqual(sut.posterPath, "https://image.tmdb.org/t/p/w200/inVq3FRqcYIRl2la8iZikYYxFNR.jpg")
    }
    
    func testNullPosterPath() {
        // Given
        let movie = MovieDTO()
        
        // When
        let sut = SearchCellViewModel(movie: movie)
        
        // Then
        XCTAssertEqual(sut.posterPath, "")
    }
}

