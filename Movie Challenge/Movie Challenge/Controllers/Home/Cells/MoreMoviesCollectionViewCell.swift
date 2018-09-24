//
//  MoreMoviesCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 24/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class MoreMoviesCollectionViewCell: UICollectionViewCell{
    
    //MARK:- Private variables
    private var delegate: SearchMoreMoviesDelegate!
    @IBOutlet weak var searchMoreMoviesButton: UIButton!
    
    //MARK:- View actions
    @IBAction func searchMoreMovies(_ sender: Any) {
        searchMoreMoviesButton.isEnabled = false
        
        delegate.searchMovies(){
            self.searchMoreMoviesButton.isEnabled = true
        }
    }
    
    //MARK:- Public methods
    func setUp(delegate: SearchMoreMoviesDelegate){
        self.delegate = delegate
    }
}
