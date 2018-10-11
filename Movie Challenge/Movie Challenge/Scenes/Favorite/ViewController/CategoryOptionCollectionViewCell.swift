//
//  CategoryCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 20/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class CategoryOptionCollectionViewCell: UICollectionViewCell{
    
    //MARK:- Constants
    static let identifier = "categoryOptionCollectionViewCell"
    
    //MARK:- Private variables
    private var viewModel: CategoryOptionViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:- Primitive methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setLittleBorderFeatured()
    }
    
    //MARK:- Private methods
    func configure(){
        nameLabel.text = viewModel.name
    }
    
    //MARK:- Public methods
    func setup(viewModel: CategoryOptionViewModel){
        self.viewModel = viewModel
        configure()
    }
}
