//
//  MoviedbAPI.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

enum Quality : String{
    case low = "w200"
    case medium = "w500"
    case high = "original"
}

class MoviedbAPI{
    private let apiKey: String = "423a7efcc5851107f96bc25a3b0c3f28"
    private let language: String = "pt-BR"
    private let baseURL: String = "https://api.themoviedb.org/3"
    private let imageBaseURL: String = "https://image.tmdb.org/t/p"
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
        return task
    }
    
    public func getPoster(path: String, quality: Quality, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let url = URL(string: imageBaseURL + "/" + quality.rawValue + "/" + path)
        return getDataFromUrl(url: url!, completion: completion)
    }
    
    public func getMovie(id: Int, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let url = URL(string: baseURL + "/movie/" + String(id) + "?api_key=" +
        apiKey + "&language=" + language)
        return getDataFromUrl(url: url!, completion: completion)
    }
    
    public func getMovies(query: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let formatedQuery: String = query.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: baseURL + "/search/movie?api_key=" + apiKey + "&query=" + formatedQuery + "&language=" + language)
        return getDataFromUrl(url: url!, completion: completion)
    }
}
