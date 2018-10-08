//
//  GenreCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 08/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    private var viewModel: GenreViewModel!

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLittleBorderFeatured()
        setCornerRadius()
    }
    
    private func configure(){
        nameLabel.text = viewModel.genre.name ?? "Genero"
        
        switch viewModel.style {
        case GenreStyle.pattern:
            nameLabel.textColor = AppConstants.textColorPattern
            nameLabel.backgroundColor = AppConstants.colorPattern
            break
        case GenreStyle.secondary:
            nameLabel.textColor = AppConstants.textColorPattern
            nameLabel.backgroundColor = AppConstants.colorSecondary
            break
        }
    }
    
    func setup(viewModel: GenreViewModel){
        self.viewModel = viewModel
        configure()
    }
}
