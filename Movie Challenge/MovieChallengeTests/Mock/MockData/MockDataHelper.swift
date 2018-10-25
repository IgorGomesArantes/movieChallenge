//
//  MockDataHelper.swift
//  MovieChallengeTests
//
//  Created by Igor Gomes Arantes on 17/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class MockDataHelper{
    
    //MARK:- Enums
    enum MockedResource: String{
        case deadpool = "Deadpool"
        case venom = "Venom"
        case popularList = "PopularList"
        case popularPage = "PopularPage"
    }
    
    static func getData(forResource resource: MockedResource) ->  Data {
        
        let bundle = Bundle(for: self)
        guard let path = bundle.path(forResource: resource.rawValue, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                fatalError("Recurso não encontrado")
        }
        
        return data
    }
}
