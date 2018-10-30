//
//  GenreViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 30/10/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class GenreViewModelTests: XCTestCase{
    
    // MARK: - Private variables
    private var genre: Genre!
    
    // MARK: - Primitive Methods
    override func setUp() {
        genre = Genre(id: 1, name: "Suspense")
    }
    
    // MARK: - Test methods
    func testPatternStyle() {
        // When
        let sut = GenreViewModel(genre: genre, style: .pattern)
        
        // Then
        XCTAssertEqual(sut.backGroundColor, AppConstants.colorPattern)
        XCTAssertEqual(sut.textColor, AppConstants.textColorPattern)
    }
    
    func testSecondaryStyle() {
        // When
        let sut = GenreViewModel(genre: genre, style: .secondary)
        
        // Then
        XCTAssertEqual(sut.backGroundColor, AppConstants.colorSecondary)
        XCTAssertEqual(sut.textColor, AppConstants.textColorPattern)
    }
    
    func testNullName() {
        // Given
        var genre = Genre()
        genre.name = nil
        
        // When
        let sut = GenreViewModel(genre: genre, style: .secondary)
        
        // Then
        XCTAssertEqual(sut.name, "Genero")
    }
    
    func testNameValue() {
        // When
        let sut = GenreViewModel(genre: genre, style: .secondary)
        
        // Then
        XCTAssertEqual(sut.name, "Suspense")
    }
}
