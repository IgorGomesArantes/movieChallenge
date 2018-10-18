//
//  MoviedbAPI.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

enum Result<Success: Codable> {
    case success(Success)
    case error(Error)
}

protocol ServiceProtocol {
    //MARK:- Methods
    func getMovieDetail(id: Int, completion: @escaping (Result<MovieDTO>) -> ())
    func getMoviePage(page: Int, sort: Sort, order: Order, completion: @escaping (Result<MoviePageDTO>) -> ())
    func getMoviePageByName(query: String, completion: @escaping (Result<MoviePageDTO>) -> ())
    func getTrendingMoviePage(page: Int, completion: @escaping (Result<MoviePageDTO>) -> ())
}

class ServiceError: Error{
    
}

class MovieService: ServiceProtocol {
    
    // MARK: - Private constants
    private let apiKey: String = "423a7efcc5851107f96bc25a3b0c3f28"
    private let language: String = "pt-BR"
    private let baseURL: String = "https://api.themoviedb.org/3"
    private let imageBaseURL: String = "https://image.tmdb.org/t/p"
    
    //MARK:- Private methods
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    //TODO:- Tirar
    static func shared() -> MovieService {
        return MovieService()
    }
    
    func getData<T:Codable>(url:URL, completion: @escaping(Result<T>) -> ()) {
        getDataFromUrl(url: url){ data, response, error in
            if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async(){
                        completion(.success(decodedData))
                    }
                }catch let parsingError{
                    DispatchQueue.main.async(){
                        completion(.error(parsingError))
                    }
                }
            }
        }
    }
    
    //MARK:- Public methods
    func getMovieDetail(id: Int, completion: @escaping (Result<MovieDTO>) -> ()) {
        let url = URL(string: baseURL + "/movie/" + String(id) + "?api_key=" + apiKey + "&language=" + language)
        getData(url: url!) { (result:Result<MovieDTO>) in
            completion(result)
        }
    }
    
    public func getMoviePageByName(query: String, completion: @escaping (Result<MoviePageDTO>) -> ()){
        
        let formatedQuery: String = query.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: baseURL + "/search/movie?api_key=" + apiKey + "&query=" + formatedQuery + "&language=" + language + "&sort_by=" + Sort.popularity.rawValue)
        
        getData(url: url!) { (result:Result<MoviePageDTO>) in
            completion(result)
        }
    }
    
    public func getMoviePage(page: Int = 1, sort: Sort, order: Order, completion: @escaping (Result<MoviePageDTO>) -> ()){
        let url = URL(string: baseURL + "/discover/movie?sort_by=" + sort.rawValue + "." + order.rawValue + "&api_key=" + apiKey + "&language=" + language + "&page=" + String(page))
        
        getData(url: url!) { (result:Result<MoviePageDTO>) in
            completion(result)
        }
    }
    
    public func getTrendingMoviePage(page: Int = 1, completion: @escaping (Result<MoviePageDTO>) -> ()){
        let url = URL(string: baseURL + "/trending/movie/day?api_key=" + apiKey + "&language=" + language + "&page=" + String(page))
        
        getData(url: url!) { (result:Result<MoviePageDTO>) in
            completion(result)
        }
    }
}
