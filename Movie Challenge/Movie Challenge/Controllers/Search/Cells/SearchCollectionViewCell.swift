//
//  SearchCollectionViewCell.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 03/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class SearchCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        posterImageView.setLittleBorderFeatured()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
    }
    
    func setUp(poster: UIImage?){
        posterImageView.image = poster ?? UIImage(named: "placeholder-image")
    }
}
