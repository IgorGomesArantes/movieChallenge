//
//  BestMovieCategoryCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class BestMovieCategoryCollectionViewCell: UICollectionViewCell{
    
    //MARK:- View variables
    @IBOutlet weak var nameViewLabel: UILabel!
    
    //MARK:- Public variables
    func setup(genre: Genre){
        setLittleBorderFeatured()
        setCornerRadius()
        nameViewLabel.text = genre.name ?? "Genero"
        nameViewLabel.adjustsFontSizeToFitWidth = true
    }
}
