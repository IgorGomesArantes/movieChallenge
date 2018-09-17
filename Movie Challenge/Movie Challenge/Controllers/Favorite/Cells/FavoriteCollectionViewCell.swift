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
    
    func setUp(title: String?, poster: UIImage?){
        DispatchQueue.main.async(){
            self.titleLabelView.text = title ?? "Não há"
            self.posterImageView.image = poster ?? UIImage(named: "placeholder-image")!
        }
    }
}
