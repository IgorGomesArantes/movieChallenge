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
    
    func onChangeSuccess(state: MovieState.Change){
        XCTAssertEqual(state, .success)
    }
    
    func testInit() {
        // Given
        let movieId = 1
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .newMovie), repository: MockedRepository(testCase: .none))
        
        // Then
        XCTAssertNotNil(sut.state)
        XCTAssertNotNil(sut.repository)
        XCTAssertNotNil(sut.service)
    }
    
    func testSaveNewMovie(){
        // Given
        let movieId = 1
        let repository = MockedRepository(testCase: .none)
        var onChangeResultState: MovieState.Change?
        var onChangeDataBaseResultState: MovieState.Change?
        
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .newMovie), repository: repository)
        
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
        XCTAssertEqual(categoryCount, 3)
        
//        do{
//            let _ = try repository.getMovie(by: movieId)
//            XCTAssert(true)
//        }catch {
//            XCTAssert(false)
//        }
    }
    
    func testRemoveFavoriteMovie(){
        // Given
        let movieId = 2
        let repository = MockedRepository(testCase: .populatedList)
        var onChangeResultState: MovieState.Change?
        var onChangeDataBaseResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .savedMovie), repository: repository)
        
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
        
        XCTAssertEqual(movieCount, 19)
        XCTAssertEqual(categoryCount, 14)
        
        do{
            let _ = try repository.getMovie(by: movieId)
            XCTAssert(false)
        }catch {
            XCTAssert(true)
        }
    }
    
    //sut = system under test
    
    func testReloadWithSavedMovie(){
        // Given
        let movieId = 2
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .savedMovie/*.none*/), repository: MockedRepository(testCase: .savedMovie))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.reload()
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertNotNil(sut.movie)
    }
    
    func testReloadWithNewMovie(){
        // Given
        let movieId = 1
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .newMovie), repository: MockedRepository(testCase: .none))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.reload()
        
        // Then
        XCTAssert(onChangeResultState == .success)
        XCTAssertNotNil(sut.movie)
    }
    
    func testReloadAndSaveOrRemoveWithError(){
        // Given
        let movieId = 0
        var onChangeResultState: MovieState.Change?
        var onChangeDataBaseResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .error(ServiceError())), repository: MockedRepository(testCase: .error(RepositoryError())))
        
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
    
    func testNumberOfGenres(){
        // Given
        let movieId = 1
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .newMovie), repository: MockedRepository(testCase: .none))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.reload()
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(sut.numberOfGenres(), 3)
    }
    
    func testGetGenreViewModel(){
        // Given
        let movieId = 1
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(testCaseDetail: .newMovie), repository: MockedRepository(testCase: .none))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.reload()
        
        let genreViewModel = sut.getGenreViewModel(index: 1)
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(genreViewModel.name, "Adventure")
        XCTAssertEqual(genreViewModel.textColor, AppConstants.textColorPattern)
        XCTAssertEqual(genreViewModel.backGroundColor, AppConstants.colorSecondary)
    }
}
