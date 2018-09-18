//
//  SuggestionCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell{
    
    //MARK:- View variables
    @IBOutlet weak var posterImageView: UIImageView!
    
    //MARK:- Public methods
    func setUp(poster: UIImage){
        posterImageView.setLittleBorderFeatured()
        posterImageView.image = poster
    }
}
