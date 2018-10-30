//
//  BaseMovieViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

// TODO: - Alterar nome
// MARK: - MovieState
struct MovieState{
    enum Change{
        case success
        case error
        case emptyResult
    }
}

// MARK: - MovieViewModel
protocol ViewModelProtocol {
    var onChange: ((MovieState.Change) -> ())? { get set }
    func reload()
}
