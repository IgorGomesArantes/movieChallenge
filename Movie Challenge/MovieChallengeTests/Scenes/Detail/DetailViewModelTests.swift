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
    
    func testInit() {
        // Given
        let movieId = 1
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: MockedRepository())
        
        // Then
        XCTAssertNotNil(sut.state)
        XCTAssertNotNil(sut.repository)
        XCTAssertNotNil(sut.service)
    }
    
    func testSaveNewMovie(){
        // Given
        let movieId = 1
        let repository = MockedRepository()
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: repository)
        
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.onChangeDataBase = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.reload()
        
        // Then
        sut.saveMovieOrRemoveFavorite()
        
        do{
            let _ = try repository.getMovie(by: movieId)
            assert(true)
        }catch {
            assert(false)
        }
    }
    
    func testRemoveFavoriteMovie(){
        // Given
        let movieId = 2
        let repository = MockedRepository()
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: repository)
        
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.onChangeDataBase = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.reload()

        // Then
        sut.saveMovieOrRemoveFavorite()
        
        do{
            let _ = try repository.getMovie(by: movieId)
            assert(false)
        }catch {
            assert(true)
        }
    }
    
    //sut = system under test
    
    func testReloadWithSavedMovie(){
        // Given
        let movieId = 2
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: MockedRepository())
        
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        // Then
        sut.reload()
        XCTAssertNotNil(sut.movie)
    }
    
    func testReloadWithNewMovie(){
        // Given
        let movieId = 1
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: MockedRepository())
        
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        // Then
        sut.reload()
        XCTAssertNotNil(sut.movie)
    }
    
    func testReloadWithError(){
        // Given
        let movieId = 0
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: MockedRepository())
        
        sut.onChange = {
            state in
            XCTAssert(state == .error)
        }
        
        // Then
        sut.reload()
        
        sut.saveMovieOrRemoveFavorite()
        
        XCTAssertNil(sut.movie)
        
        XCTAssertEqual(sut.numberOfGenres(), 0)
    }
    
    func testNumberOfGenres(){
        // Given
        let movieId = 1
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: MockedRepository())
        
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.reload()
        
        // Then
        XCTAssertEqual(sut.numberOfGenres(), 3)
    }
    
    func testGetGenreViewModel(){
        // Given
        let movieId = 1
        
        // When
        let sut = DetailViewModel(movieId: movieId, service: MockedService(), repository: MockedRepository())
        
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.reload()
        
        // Then
        let genreViewModel = sut.getGenreViewModel(index: 1)
        
        XCTAssertEqual(genreViewModel.name, "Adventure")
        XCTAssertEqual(genreViewModel.textColor, AppConstants.textColorPattern)
        XCTAssertEqual(genreViewModel.backGroundColor, AppConstants.colorSecondary)
    }
    
    
}
