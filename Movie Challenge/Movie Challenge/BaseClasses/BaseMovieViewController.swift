//
//  BaseMovieViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 01/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class BaseMovieViewController: UIViewController{
    
    var viewModel: BaseMovieViewModel!
    
    func viewModelStateChange(change: MovieListState.Change){
        preconditionFailure("This method must be overridden")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    func bindViewModel(){
        preconditionFailure("This method must be overridden")
    }
}
