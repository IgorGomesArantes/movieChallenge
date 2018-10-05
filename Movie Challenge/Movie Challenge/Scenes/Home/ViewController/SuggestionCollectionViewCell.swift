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
    func setup(movie: MovieDTO){
        posterImageView.setLittleBorderFeatured()
        posterImageView.sd_setImage(with: URL(string: AppConstants.BaseImageURL + Quality.low.rawValue + "/" + (movie.poster_path ?? "")), placeholderImage: UIImage(named: AppConstants.placeHolder))
    }
}
