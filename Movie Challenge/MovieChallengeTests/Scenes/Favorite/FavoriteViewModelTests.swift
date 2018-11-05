//
//  FavoriteViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 16/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class FavoriteViewModelTests: XCTestCase {
    
    // MARK: - Test methods
    func testPopulatedList(){
        // Given
        var onChangeResultState: MovieState.Change?
        
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .populatedList))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        // When
        sut.reload()
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertEqual(sut.numberOfRows(), 2)
        XCTAssertEqual(sut.movie(row: 1).id, 2)
        XCTAssertEqual(sut.numberOfCategories(), 6)
        XCTAssertEqual(sut.selectedCategoryName, "Todos os filmes")
    }

    func testEmptyList(){
        // Given
        var onChangeResultState: MovieState.Change?
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .none))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        // When
        sut.reload()
        
        // Then
        XCTAssertEqual(onChangeResultState, .emptyResult)
    }
    
    func testError(){
        // Given
        var onChangeDataBaseResultState: MovieState.Change?
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .error(RepositoryError())))
        
        sut.onChangeDataBase = { state in
            onChangeDataBaseResultState = state
        }
        
        // When
        sut.reload()
    
        // Then
        XCTAssertEqual(onChangeDataBaseResultState, .error)
    }
    
    func testSelectCategory(){
        // Given
        var onChangeResultState: MovieState.Change?
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .populatedList))

        sut.onChange = { state in
            onChangeResultState = state
        }

        // When
        sut.selectedCategoryIndex = 1

        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertEqual(sut.numberOfRows(), 1)
        XCTAssertEqual(sut.movie(row: 0).id, 2)
        XCTAssertEqual(sut.selectedCategoryName, "Action")
    }
    
    func testGetCategoryOptionViewModel(){
        // Given
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .populatedList))
        
        // When
        let categoryOptionViewModel = sut.getCategoryOptionViewModel(index: 1)
        
        // Then
        XCTAssertEqual(categoryOptionViewModel.name, "Action")
    }
    
    func testGetDetailViewModel(){
        // Given
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .populatedList))
        
        // When
        let detailViewModel: DetailViewModel? = sut.getDetailViewModel(movieId: 1)
        
        // Then
        XCTAssertNotNil(detailViewModel)
    }
    
    func testGetFavoriteCellViewModel(){
        // Given
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .populatedList))
        
        let delegate = FavoriteCellViewModelDelegateTests()
        
        // When
        let favoriteCellViewModel: FavoriteCellViewModel? = sut.getFavoriteCellViewModel(delegate: delegate, index: 1)
        
        favoriteCellViewModel?.removeFromFavorite()
        favoriteCellViewModel?.gotoDetailScene()
        
        // Then
        XCTAssertNotNil(favoriteCellViewModel)
        XCTAssertEqual(delegate.changeMovieId, 2)
        XCTAssertEqual(delegate.removeId, 2)
    }
    
    func testChangeDataBase(){
        // Given
        var onChangeResultState: MovieState.Change?
        var onChangeDataBaseResultState: MovieState.Change?
        
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .populatedList))
        
        sut.onChange = { state in
            onChangeResultState = state
        }

        sut.onChangeDataBase = { state in
            onChangeDataBaseResultState = state
        }
        
        // When
        sut.changeDataBase(change: .success)
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        
        // When
        sut.changeDataBase(change: .error)
        
        // Then
        XCTAssertEqual(onChangeDataBaseResultState, .error)
    }
}
