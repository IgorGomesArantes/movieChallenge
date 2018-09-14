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
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
}
