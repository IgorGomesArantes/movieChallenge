//
//  MoviedbAPI.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

enum Response<Result: Codable> {
    case success(Result)
    case error(Error)
}

protocol MovieServiceProtocol {
    //MARK:- Methods
    func getMovieDetail(id: Int, completion: @escaping (Response<MovieDTO>) -> ())
    func getMoviePage(page: Int, sort: Sort, order: Order, completion: @escaping (Response<MoviePageDTO>) -> ())
    func getMoviePageByName(query: String, completion: @escaping (Response<MoviePageDTO>) -> ())
    func getTrendingMoviePage(page: Int, completion: @escaping (Response<MoviePageDTO>) -> ())
}

class ServiceError: Error{
    
}

class HTTPMovieService: MovieServiceProtocol {
    
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
//    static func shared() -> HTTPMovieService {
//        return HTTPMovieService()
//    }
    
    func getData<T:Codable>(url:URL, completion: @escaping(Response<T>) -> ()) {
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
    func getMovieDetail(id: Int, completion: @escaping (Response<MovieDTO>) -> ()) {
        let url = URL(string: baseURL + "/movie/" + String(id) + "?api_key=" + apiKey + "&language=" + language)
        getData(url: url!) { (result:Response<MovieDTO>) in
            completion(result)
        }
    }
    
    public func getMoviePageByName(query: String, completion: @escaping (Response<MoviePageDTO>) -> ()){
        
        let formatedQuery: String = query.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: baseURL + "/search/movie?api_key=" + apiKey + "&query=" + formatedQuery + "&language=" + language + "&sort_by=" + Sort.popularity.rawValue)
        
        getData(url: url!) { (result:Response<MoviePageDTO>) in
            completion(result)
        }
    }
    
    public func getMoviePage(page: Int = 1, sort: Sort, order: Order, completion: @escaping (Response<MoviePageDTO>) -> ()){
        let url = URL(string: baseURL + "/discover/movie?sort_by=" + sort.rawValue + "." + order.rawValue + "&api_key=" + apiKey + "&language=" + language + "&page=" + String(page))
        
        getData(url: url!) { (result:Response<MoviePageDTO>) in
            completion(result)
        }
    }
    
    public func getTrendingMoviePage(page: Int = 1, completion: @escaping (Response<MoviePageDTO>) -> ()){
        let url = URL(string: baseURL + "/trending/movie/day?api_key=" + apiKey + "&language=" + language + "&page=" + String(page))
        
        getData(url: url!) { (result:Response<MoviePageDTO>) in
            completion(result)
        }
    }
}
