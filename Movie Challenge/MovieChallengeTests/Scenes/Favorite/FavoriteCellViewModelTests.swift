//
//  FavoriteCellViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 05/11/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class FavoriteCellViewModelDelegateTests: FavoriteCellViewModelDelegate{
    // MARK: - Public variables
    var removeId = 0
    var changeMovieId = 0
    
    // MARK: - Public methods
    func removeFavoriteMovie(id: Int) {
        removeId = id
    }
    
    func changeToMovieDetail(movieId: Int) {
        changeMovieId = movieId
    }
}

class FavoriteCellViewModelTests: XCTestCase{
    
    // MARK: - Private variables
    private var delegate: FavoriteCellViewModelDelegateTests!
    private var sut: FavoriteCellViewModel!
    private var onChangeResultState: MovieState.Change?
    
    // MARK: - Primitive methods
    override func setUp() {
        let deadpool = try! JSONDecoder().decode(MovieDTO.self, from: MockDataHelper.getData(forResource: .deadpool))
        
        delegate = FavoriteCellViewModelDelegateTests()
        
        sut = FavoriteCellViewModel(delegate: delegate, movie: deadpool)
        
        sut.onChange = { state in
            self.onChangeResultState = state
        }
    }
    
    // MARK: - Test methods
    func testProgressBarScore(){
        // Then
        XCTAssertEqual(sut.progressBarScore, 0.75)
    }
    
    func testZeroVoteAverageProgressBarScore(){
        // Given
        let sut = FavoriteCellViewModel(delegate: FavoriteCellViewModelDelegateTests(), movie: MovieDTO())
        
        // Then
        XCTAssertEqual(sut.progressBarScore, 0.0)
    }
    
    func testGetFavoriteCellViewModel(){
        // When
        sut.removeFromFavorite()
        sut.gotoDetailScene()
        
        // Then
        XCTAssertEqual(delegate.changeMovieId, 1)
        XCTAssertEqual(delegate.removeId, 1)
    }
    
    func testZeroNumberOfGenres(){
        // Given
        let sut = FavoriteCellViewModel(delegate: FavoriteCellViewModelDelegateTests(), movie: MovieDTO())
        
        // Then
        XCTAssertEqual(sut.numberOfGenres(), 0)
    }
    
    func testNumberOfGenres(){
        // Then
        XCTAssertEqual(sut.numberOfGenres(), 2)
    }
    
    func testReload(){
        // When
        sut.reload()
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
    }
    
    func testGetGenreViewModel(){
        // When
        let genreViewModel = sut.getGenreViewModel(index: 1)
        
        // Then
        XCTAssertEqual(genreViewModel.backGroundColor, AppConstants.colorPattern)
        XCTAssertEqual(genreViewModel.textColor, AppConstants.textColorPattern)
        XCTAssertEqual(genreViewModel.name, "Comedy")
    }
}
