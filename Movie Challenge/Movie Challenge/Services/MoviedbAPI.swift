//
//  MoviedbAPI.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class MoviedbAPI{
    let apiKey: String = "423a7efcc5851107f96bc25a3b0c3f28"
    let language: String = "pt-BR"
    let baseURL: String = "https://api.themoviedb.org/3"
    
    func getMovie(id: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/100?api_key=423a7efcc5851107f96bc25a3b0c3f28&language=pt-BR")
        
        let session = URLSession.shared
        if let usableUrl = url {
            let task = session.dataTask(with: usableUrl, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        print(stringData)
                        
                        do {
                            print("Entrou")
                            let decoder = JSONDecoder()
                            let model = try decoder.decode(Movie.self, from:
                                data)
                            print(model)
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                }
            })
            task.resume()
        }
    }
}
