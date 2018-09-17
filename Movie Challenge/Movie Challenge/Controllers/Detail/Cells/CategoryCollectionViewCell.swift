//
//  DetailCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 10/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabelView: UILabel!
    
    func setUp(name: String?){
        setCornerRadius()
        self.nameLabelView.text = name ?? "Genero"
    }
}
