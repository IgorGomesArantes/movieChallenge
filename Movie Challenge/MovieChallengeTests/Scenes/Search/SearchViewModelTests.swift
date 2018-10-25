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
    
    var sut: SearchViewModel!
    
    override func setUp() {
        sut = SearchViewModel(service: MockedService(testCasePage: .populatedPage))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit(){
        XCTAssertEqual(sut.searchQuery, "")
        XCTAssertNotNil(sut.state)
    }
    
    func testChangeSearchEmptyText(){
        // Then
        sut.onChange = {
            state in
            XCTAssert(state == .emptyResult)
        }
        
        // When
        sut.searchQuery = ""
    }
    
    func testChangeSearchEmptyResult(){
        // Then
        sut.onChange = {
            state in
            XCTAssert(state == .none)
        }
        
        // When
        sut.searchQuery = "lord of the mirror 2"
    }
    
    func testChangePopularSearch(){
        // Then
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        // When
        sut.searchQuery = "popular"
    }
    
    func testChangeServiceErrorSearch(){
        // Then
        sut.onChange = {
            state in
            XCTAssert(state == .none)
        }
        
        // When
        sut.searchQuery = "error"
    }
    
    func testNumberOfSections(){
        // Then
        XCTAssertEqual(sut.numberOfSections(), 1)
    }
    
    func testNumberOfRows(){
        // Given
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        // When
        sut.searchQuery = "popular"
        
        // Then
        XCTAssertEqual(sut.numberOfRows(), 20)
    }
    
    func testGetSearchCellViewModel(){
        // Given
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.searchQuery = "popular"
        
        // When
        let cellViewModel = sut.getSearchCellViewModel(index: 1)
        
        // Then
        XCTAssertEqual(cellViewModel.posterPath, "https://image.tmdb.org/t/p/w200/wrFpXMNBRj2PBiN4Z5kix51XaIZ.jpg")
    }
    
    func testGetDetailViewModel(){
        // Given
        sut.onChange = {
            state in
            XCTAssert(state == .success)
        }
        
        sut.searchQuery = "popular"
        
        // When
        let detailViewModel = sut.getDetailViewModel(index: 0)
        
        // Then
        XCTAssertNotNil(detailViewModel)
    }
}
