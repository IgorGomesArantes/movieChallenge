//
//  SearchViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 19/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class SearchViewModelTests: XCTestCase{
    
    // MARK: - Private variables
    private var sut: SearchViewModel!
    private var onChangeResultState: MovieState.Change?
    
    // MARK: - Primitive methods
    override func setUp() {
        sut = SearchViewModel(service: MockedMovieService(testCase: .populatedPage))
        
        sut.onChange = { state in
            self.onChangeResultState = state
        }
    }
    
    // MARK: - Test methods
    func testInit(){
        // Given
        let sut = SearchViewModel(service: MockedMovieService(testCase: .none))
        
        // Then
        XCTAssertEqual(sut.searchQuery, "")
    }
    
    func testSearchEmptyText(){
        // When
        sut.searchQuery = ""
        
        // Then
        XCTAssertEqual(onChangeResultState, .emptyResult)
        XCTAssertEqual(sut.numberOfRows(), 0)
    }
    
    func testSearchEmptyResult(){
        // Given
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = SearchViewModel(service: MockedMovieService(testCase: .emptyPage))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.searchQuery = "matrix"
        
        // Then
        XCTAssertEqual(onChangeResultState, .emptyResult)
        XCTAssertEqual(sut.numberOfRows(), 0)
    }
    
    func testPopulatedPageSearch(){
        // When
        sut.searchQuery = "matrix"
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(sut.numberOfRows(), 20)
    }
    
    func testChangeServiceErrorSearch(){
        // Given
        var onChangeResultState: MovieState.Change?
        
        // When
        let sut = SearchViewModel(service: MockedMovieService(testCase: .error(ServiceError())))
        
        sut.onChange = { state in
            onChangeResultState = state
        }
        
        sut.searchQuery = "matrix"
        
        // Then
        XCTAssertEqual(onChangeResultState, .error)
    }
    
    func testNumberOfSections(){
        // Then
        XCTAssertEqual(sut.numberOfSections(), 1)
    }
    
    func testGetSearchCellViewModel(){
        // Given
        sut.searchQuery = "matrix"
        
        // When
        let cellViewModel = sut.getSearchCellViewModel(index: 1)
        
        // Then
        XCTAssertEqual(onChangeResultState, .success)
        XCTAssertEqual(cellViewModel.posterPath, "https://image.tmdb.org/t/p/w200/wrFpXMNBRj2PBiN4Z5kix51XaIZ.jpg")
    }
    
    func testGetDetailViewModel(){
        // Given
        sut.searchQuery = "matrix"
        
        // When
        let detailViewModel: DetailViewModel? = sut.getDetailViewModel(index: 0)
        
        // Then
        XCTAssertNotNil(detailViewModel)
    }
}
