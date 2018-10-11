//
//  SuggestionCollectionViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell{
    
    //MARK:- Constants
    static let identifier = "suggestionMovieCollectionViewCell"
    
    //MARK:- Private variables
    private var viewModel: SuggestionCollectionCellViewModel!
    
    //MARK:- View variables
    @IBOutlet weak var posterImageView: UIImageView!
    
    //MARK:- Private methods
    private func configure(){
        posterImageView.setLittleBorderFeatured()
        posterImageView.sd_setImage(with: URL(string: viewModel.posterPath), placeholderImage: UIImage(named: AppConstants.placeHolder))
    }
    
    //MARK:- Public methods
    func setup(viewModel: SuggestionCollectionCellViewModel){
        self.viewModel = viewModel
        configure()
    }
}
