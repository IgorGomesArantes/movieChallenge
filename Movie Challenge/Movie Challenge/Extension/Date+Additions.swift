//
//  Date+Additions.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 20/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
