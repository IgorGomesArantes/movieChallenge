//
//  DetailCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 10/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    //MARK:- View variables
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:- Public methods
    func setUp(name: String){
        //setCornerRadius()
        setBorderFeatured()
        self.nameLabel.text = name
    }
}
