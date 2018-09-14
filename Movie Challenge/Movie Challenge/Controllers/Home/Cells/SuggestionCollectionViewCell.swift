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
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    func setUp(poster: UIImage){
        DispatchQueue.main.async(){
            self.posterImageView.image = poster
        }
    }
}
