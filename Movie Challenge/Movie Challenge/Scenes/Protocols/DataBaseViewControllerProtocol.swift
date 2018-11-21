//
//  DataBaseViewControllerProtocol.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 30/10/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

protocol DataBaseViewControllerProtocol {
    func viewModelDataBaseChange(change: MovieState.Change)
}