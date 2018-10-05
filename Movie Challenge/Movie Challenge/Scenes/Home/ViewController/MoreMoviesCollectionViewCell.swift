//
//  MoreMoviesCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 24/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

protocol MoreMoviesCollectionViewCellDelegate {
    func searchMoreMovies(completion: @escaping () -> ())
}

//Erro ao dar isEnableTrue
class MoreMoviesCollectionViewCell: UICollectionViewCell{
    
    //MARK:- Private variables
    private var delegate: MoreMoviesCollectionViewCellDelegate!
    @IBOutlet weak var searchMoreMoviesButton: UIButton!
    
    //MARK:- View actions
    @IBAction func searchMoreMovies(_ sender: Any) {
        //searchMoreMoviesButton.isEnabled = false
        
        delegate.searchMoreMovies(){
            self.searchMoreMoviesButton.isEnabled = true
        }
    }
    
    //MARK:- Public methods
    func setUp(delegate: MoreMoviesCollectionViewCellDelegate){
        self.delegate = delegate
    }
}
