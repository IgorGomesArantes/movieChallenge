//
//  BaseMovieViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

protocol MovieViewController{
    func viewModelStateChange(change: MovieState.Change)
    func bindViewModel()
}

protocol DataBaseViewController{
    func viewModelDataBaseChange(change: MovieState.Change)
}
