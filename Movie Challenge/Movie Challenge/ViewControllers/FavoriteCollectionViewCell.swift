//
//  FavoriteCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 11/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var poster_path: String!
    
    override func awakeFromNib() {
        
    }
    
}
