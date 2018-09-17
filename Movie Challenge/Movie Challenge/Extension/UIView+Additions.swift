//
//  UIView+Additions.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 14/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func setCornerRadius(){
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    func setBorderFeatured(){
        setCornerRadius()
        layer.borderWidth = 4
        layer.borderColor = #colorLiteral(red: 0.1333333333, green: 0.1843137255, blue: 0.2431372549, alpha: 1)
    }
    
    func setLittleBorderFeatured(){
        setCornerRadius()
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.1333333333, green: 0.1843137255, blue: 0.2431372549, alpha: 1)
    }
    
    func setBigBorderFeatured(){
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.1333333333, green: 0.1843137255, blue: 0.2431372549, alpha: 1)
    }
}
