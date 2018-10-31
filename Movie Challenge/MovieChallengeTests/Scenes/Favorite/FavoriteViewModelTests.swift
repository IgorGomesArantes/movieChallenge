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
    func testInit(){
        // Given
        let sut = FavoriteViewModel(repository: MockedRepository(testCase: .none))

        // Then
        XCTAssertNotNil(sut.repository)
    }
    
    
}
