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
    
    //MARK:- Constants
    static let identifier: String = "searchCollectionViewCell"
    
    //MARK:- Private variables
    private var viewModel: SearchCellViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var posterImage: UIImageView!
    
    //MARK:- Primitive functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImage.setLittleBorderFeatured()
    }
    
    //MARK:- Private functions
    func configure(){
        posterImage.sd_setImage(with: URL(string: viewModel.posterPath), placeholderImage: UIImage(named: AppConstants.placeHolder))
    }
    
    //MARK:- Public functions
    func setup(viewModel: SearchCellViewModel){
        self.viewModel = viewModel
        
        configure()
    }
}
