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
    
    func getColor() -> CGColor{
        return #colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3137254902, alpha: 1)
    }
    
    func setCornerRadius(){
        layer.cornerRadius = 3
        layer.masksToBounds = true
    }
    
    func setBorderFeatured(){
        setCornerRadius()
        layer.borderWidth = 2
        layer.borderColor = getColor()
    }
    
    func setLittleBorderFeatured(){
        //setCornerRadius()
        layer.borderWidth = 1
        layer.borderColor = getColor()
    }
    
    func setBigBorderFeatured(){
        layer.borderWidth = 2
        layer.borderColor = getColor()
    }
}
