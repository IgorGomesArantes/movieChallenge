//
//  MovieChallengeTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 11/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class MovieChallengeTests: XCTestCase {

    var searchViewModel: SearchCellViewModel!
    
    override func setUp() {
        var movie = MovieDTO()
        movie.poster_path = "teste.jpg"
        searchViewModel = SearchCellViewModel(movie: movie)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
//        XCTAssertTrue(searchViewModel.posterPath == "https://image.tmdb.org/t/p/w200/teste.jpg")
//        debugPrint(searchViewModel.posterPath)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
