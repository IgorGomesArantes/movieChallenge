//
//  DetailViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 17/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class DetailViewModelTests: XCTestCase{
    
    // MARK: - Test methods
    func testInit() {
        // Given
        let movieId = 1
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .none), repository: MockedRepository(testCase: .none))
        
        // Then
        XCTAssertNotNil(sut.repository)
        XCTAssertNotNil(sut.service)
    }
    
    func testSaveNewMovie() {
        // Given
        let movieId = 1
        let repository = MockedRepository(testCase: .none)
        var onChangeResultState: MovieState.Change?
        var onChangeDataBaseResultState: MovieState.Change?
        
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .newMovie), repository: repository)
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.onChangeDataBase = { state in
            onChangeDataBaseResultState = state
        }
        
        // When
        sut.reload()
        sut.saveMovieOrRemoveFavorite()
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(onChangeDataBaseResultState, .success)
        
        let movieCount = try! repository.getAllMovies().count
        let categoryCount = try! repository.getAllCategories().count
        
        XCTAssertEqual(movieCount, 1)
        XCTAssertEqual(categoryCount, 2)
    }
    
    func testRemoveFavoriteMovie() {
        // Given
        let movieId = 2
        let repository = MockedRepository(testCase: .populatedList)
        var onChangeResultState: MovieState.Change?
        var onChangeDataBaseResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .none), repository: repository)
        
        sut.onChange = { state in
           onChangeResultState = state
        }
        
        sut.onChangeDataBase = { state in
           onChangeDataBaseResultState = state
        }
        
        sut.reload()
        sut.saveMovieOrRemoveFavorite()
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(onChangeDataBaseResultState, .success)
        
        let movieCount = try! repository.getAllMovies().count
        let categoryCount = try! repository.getAllCategories().count
        
        XCTAssertEqual(movieCount, 1)
        XCTAssertEqual(categoryCount, 3)
    }
    
    //sut = system under test
    
    func testReloadWithSavedMovie() {
        // Given
        let movieId = 2
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .none), repository: MockedRepository(testCase: .savedMovie))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.reload()
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertNotNil(sut.movie)
    }
    
    func testReloadWithNewMovie() {
        // Given
        let movieId = 1
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .newMovie), repository: MockedRepository(testCase: .none))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.reload()
        
        // Then
        XCTAssert(onChangeResultState == .success)
        XCTAssertNotNil(sut.movie)
    }
    
    func testReloadAndSaveOrRemoveWithError() {
        // Given
        let movieId = 0
        var onChangeResultState: MovieState.Change?
        var onChangeDataBaseResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .error(ServiceError())), repository: MockedRepository(testCase: .error(RepositoryError())))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.onChangeDataBase = { state in
            onChangeDataBaseResultState = state
        }
        
        sut.reload()
        sut.saveMovieOrRemoveFavorite()
        
        // Then
        XCTAssertNil(sut.movie)
        XCTAssertEqual(sut.numberOfGenres(), 0)
        XCTAssertEqual(onChangeResultState, .error)
        XCTAssertEqual(onChangeDataBaseResultState, .error)
    }
    
    func testNumberOfGenres() {
        // Given
        let movieId = 1

        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .newMovie), repository: MockedRepository(testCase: .none))
        sut.reload()
        
        // Then
        XCTAssertEqual(sut.numberOfGenres(), 2)
    }
    
    func testGetGenreViewModel() {
        // Given
        let movieId = 1

        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .newMovie), repository: MockedRepository(testCase: .none))
        sut.reload()
        
        let genreViewModel = sut.getGenreViewModel(index: 1)
        
        // Then
        XCTAssertEqual(genreViewModel.name, "Comedy")
        XCTAssertEqual(genreViewModel.textColor, AppConstants.textColorPattern)
        XCTAssertEqual(genreViewModel.backGroundColor, AppConstants.colorSecondary)
    }
    
    func testMovieValues() {
        // Given
        let movieId = 1
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .none), repository: MockedRepository(testCase: .savedMovie))
        sut.reload()
        
        // Then
        XCTAssertEqual(sut.posterPath, "https://image.tmdb.org/t/p/original/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg")
        XCTAssertEqual(sut.title, "Venom")
        XCTAssertEqual(sut.voteAverage, "6.6")
        XCTAssertEqual(sut.voteCount, "(1199)")
        XCTAssertEqual(sut.overview, "When Eddie Brock acquires the powers of a symbiote, he will have to release his alter-ego “Venom” to save his life.")
        XCTAssertEqual(sut.year, "2018")
        XCTAssertEqual(sut.runtime, "1h52m")
        XCTAssertEqual(sut.creationDate, "31-10-2018")
    }
    
    func testMovieNullValues() {
        // Given
        let movieId = 3

        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .none), repository: MockedRepository(testCase: .nilFieldsMovie))
        sut.reload()
        
        // Then
        XCTAssertEqual(sut.overview, NSLocalizedString("Empty overview", comment: ""))
        XCTAssertEqual(sut.year, NSLocalizedString("Empty year", comment: ""))
        XCTAssertEqual(sut.creationDate, NSLocalizedString("Empty creation date", comment: ""))
    }
    
    func testMovieValuesWhenNull() {
        // Given
        let movieId = 0
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedMovieService(testCase: .none), repository: MockedRepository(testCase: .none))
        sut.reload()
        
        // Then
        XCTAssertEqual(sut.posterPath, NSLocalizedString("Empty poster path", comment: ""))
        XCTAssertEqual(sut.title, NSLocalizedString("Unknown title", comment: ""))
        XCTAssertEqual(sut.voteAverage, NSLocalizedString("Empty vote average", comment: ""))
        XCTAssertEqual(sut.voteCount, NSLocalizedString("Empty vote count", comment: ""))
        XCTAssertEqual(sut.overview, NSLocalizedString("Empty overview", comment: ""))
        XCTAssertEqual(sut.year, NSLocalizedString("Empty year", comment: ""))
        XCTAssertEqual(sut.runtime, NSLocalizedString("Empty runtime", comment: ""))
        XCTAssertEqual(sut.creationDate, NSLocalizedString("Empty creation date", comment: ""))
    }
}
