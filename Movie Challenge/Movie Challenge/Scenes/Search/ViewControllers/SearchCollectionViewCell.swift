//
//  SearchCollectionViewCell.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 03/09/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell : UICollectionViewCell{
    
    //MARK:- View variables
    @IBOutlet weak var posterImage: UIImageView!
    
    //MARK:- Primitive functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImage.setLittleBorderFeatured()
    }
    
    //MARK:- Public functions
    func setUp(posterURL: String){
        posterImage.sd_setImage(with: URL(string: AppConstants.BaseImageURL + Quality.low.rawValue + "/" + posterURL), placeholderImage: UIImage(named: AppConstants.placeHolder))
    }
}
