//
//  MoviedbAPI.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class MovieService{
    
    //MARK:- Private constants
    private let apiKey: String = "423a7efcc5851107f96bc25a3b0c3f28"
    private let language: String = "pt-BR"
    private let baseURL: String = "https://api.themoviedb.org/3"
    private let imageBaseURL: String = "https://image.tmdb.org/t/p"
    
    //MARK:- Singleton implementation
    private static var sharedInstance: MovieService = {
        let instance = MovieService()
        
        return instance
    }()
    
    private init(){}
    
    class func shared() -> MovieService{
        return sharedInstance
    }
    
    //MARK:- Private methods
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            
        }
        task.resume()
        return task
    }
    
    //MARK:- Public metho
    @discardableResult
    public func getMovieDetail(id: Int, completion: @escaping (MovieDTO, URLResponse?, Error?) -> ()) -> URLSessionTask{
        
        let url = URL(string: baseURL + "/movie/" + String(id) + "?api_key=" + apiKey + "&language=" + language)
        
        let task = getDataFromUrl(url: url!){ data, response, error in
            if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(MovieDTO.self, from: data)
                    
                    DispatchQueue.main.async(){
                        completion(movie, response, error)
                    }
                }catch let parsingError{
                    print("Decoder Exception: ", parsingError)
                }
            }
        }
        
        return task
    }
    
    @discardableResult
    public func getMoviePageByName(query: String, completion: @escaping (MoviePageDTO, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        
        let formatedQuery: String = query.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: baseURL + "/search/movie?api_key=" + apiKey + "&query=" + formatedQuery + "&language=" + language + "&sort_by=" + Sort.popularity.rawValue)
        
        let task = getDataFromUrl(url: url!){ data, response, error in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let moviePage = try decoder.decode(MoviePageDTO.self, from: data)
                    
                    DispatchQueue.main.async(){
                        completion(moviePage, response, error)
                    }
                } catch let parsingError {
                    completion(MoviePageDTO(), response, error)
                    
                    print("Decoder Exception: ", parsingError)
                }
            }
        }
        return task
    }
    
    @discardableResult
    public func getMoviePage(page: Int = 1, sort: Sort, order: Order, completion: @escaping (MoviePageDTO, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let url = URL(string: baseURL + "/discover/movie?sort_by=" + sort.rawValue + "." + order.rawValue + "&api_key=" + apiKey + "&language=" + language + "&page=" + String(page))
        
        let task = getDataFromUrl(url: url!){ data, response, error in
            if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let moviePage = try decoder.decode(MoviePageDTO.self, from: data)
                    
                    DispatchQueue.main.async(){
                        completion(moviePage, response, error)
                    }
                }catch let parsingError{
                    print("Decoder Exception: ", parsingError)
                }
            }
        }
        
        return task
    }
    
    @discardableResult
    public func getPoster(path: String, quality: Quality, completion: @escaping (UIImage, URLResponse?, Error?) -> ()) ->  URLSessionDataTask{
        let url = URL(string: imageBaseURL + "/" + quality.rawValue + "/" + path)
        
        let task = getDataFromUrl(url: url!){ data, response, error in
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async(){
                    completion(image, response, error)
                }
            }
        }
        
        return task
    }
    
    @discardableResult
    public func getPosterData(path: String, quality: Quality, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let url = URL(string: imageBaseURL + "/" + quality.rawValue + "/" + path)
        
        let task = getDataFromUrl(url: url!){ data, response, error in
            if let data = data{
                DispatchQueue.main.async(){
                    completion(data, response, error)
                }
            }
        }
        
        return task
    }
    
    @discardableResult
    public func getTrendingMovies(page: Int = 1, completion: @escaping (MoviePageDTO?, URLResponse?, Error?) -> ()) -> URLSessionDataTask{
        let url = URL(string: baseURL + "/trending/movie/day?api_key=" + apiKey + "&language=" + language + "&page=" + String(page))
        
        let task = getDataFromUrl(url: url!){ (data, response, error) in
            if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let moviePage = try decoder.decode(MoviePageDTO.self, from: data)
                    
                    DispatchQueue.main.async(){
                        completion(moviePage, response, error)
                    }
                    
                }catch let parsingError{
                    print("Decoder Exception: ", parsingError)
                }
            }
        }
        
        return task
    }
}
