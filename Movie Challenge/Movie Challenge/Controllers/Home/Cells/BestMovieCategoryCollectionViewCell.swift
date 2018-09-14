//
//  BestMovieCategoryCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class BestMovieCategoryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var nameViewLabel: UILabel!
    
    func setUp(name: String?){
        nameViewLabel.text = name ?? "Genero"
        nameViewLabel.adjustsFontSizeToFitWidth = true
    }
}
