//
//  BaseMovieViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
    func viewModelStateChange(change: MovieState.Change)
    func bindViewModel()
}
