//
//  CategoryOptionViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 09/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class CategoryOptionViewModel{
    
    //MARK:- Private variables
    private let category: CategoryDTO
    
    //MARK:- Public variables
    var name: String{
        return category.name ?? "Genero"
    }
    
    //MARK:- Public methods
    init(category: CategoryDTO){
        self.category = category
    }
}
