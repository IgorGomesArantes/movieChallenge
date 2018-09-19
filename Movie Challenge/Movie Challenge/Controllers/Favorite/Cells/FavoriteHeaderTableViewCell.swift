//
//  FavoriteHeaderTableViewCell.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 11/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteHeaderTableViewCell: UITableViewCell{
    
    @IBOutlet weak var categoryLabelView: UILabel!
    @IBOutlet weak var numberOfMoviesLabelView: UILabel!
    
    func setUp(categoryName: String?, numberOfMovies: Int?){
        //DispatchQueue.main.async(){
            self.categoryLabelView.text = categoryName ?? "Genero"
            let number: Int = numberOfMovies ?? 0
            self.numberOfMoviesLabelView.text = "(" + String(number) + ")"
        //}
    }
}
