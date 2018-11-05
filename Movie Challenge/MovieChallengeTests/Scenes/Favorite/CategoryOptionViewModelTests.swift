//
//  CategoryOptionViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 05/11/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import XCTest
@testable import Movie_Challenge

class CategoryOptionViewModelTests: XCTestCase {

    // MARK: - Test methods
    func testName(){
        // Given
        let category = CategoryDTO(id: 1, name: "Action", movies: nil)
        
        // When
        let sut = CategoryOptionViewModel(category: category)
        
        // Then
        XCTAssertEqual(sut.name, "Action")
    }
    
    func testNullName(){
        // Given
        let category = CategoryDTO(id: nil, name: nil, movies: nil)
        
        // When
        let sut = CategoryOptionViewModel(category: category)
        
        // Then
        XCTAssertEqual(sut.name, "Genero")
    }
}
