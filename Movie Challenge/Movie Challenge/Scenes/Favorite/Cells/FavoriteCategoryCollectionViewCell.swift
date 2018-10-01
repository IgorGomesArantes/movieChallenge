//
//  FavoriteCategoryCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 20/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCategoryCollectionViewCell: UICollectionViewCell{
    
    //MARK:- View variables
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:- Primitive methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setLittleBorderFeatured()
    }
    
    //MARK:- Public methods
    func setUp(name: String){
        nameLabel.text = name
    }
}
