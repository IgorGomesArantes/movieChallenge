//
//  movieService.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 29/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

//Utilizar o DTO
class MovieService{
    
    private static var sharedInstance: MovieService = {
        let instance = MovieService()
        
        return instance
    }()
    
    
    private init(){

    }
    
    class func shared() -> MovieService{
        return sharedInstance
    }
    
    //TODO Corrigir Funcao
    private func movieDTOToEntity(movieDTO: MovieDTO) -> MovieEntity{
        
        let movieEntity = MovieEntity()

        movieEntity.setValue(movieDTO.overview, forKey: "overview")
        movieEntity.setValue(movieDTO.poster_path, forKey: "poster_path")
        movieEntity.setValue(movieDTO.title, forKey: "title")
        movieEntity.setValue(movieDTO.vote_average, forKey: "vote_average")
        movieEntity.setValue(Int32(movieDTO.id!), forKey: "id")
        movieEntity.setValue(Int32(movieDTO.vote_count!), forKey: "vote_count")
        
        return movieEntity
    }
    
    private func movieEntityToDTO(movieEntity: MovieEntity) -> MovieDTO{
        var movieDTO = MovieDTO()
        movieDTO.id = Int(movieEntity.id)
        movieDTO.overview = movieEntity.overview
        movieDTO.poster_path = movieEntity.poster_path
        movieDTO.title = movieEntity.title
        movieDTO.vote_average = movieEntity.vote_average
        movieDTO.vote_count = Int(movieEntity.vote_count)
        movieDTO.poster = movieEntity.poster
        
        return movieDTO
    }
    
    private func movieEntityListToDTOList(movieEntityList: [MovieEntity]) -> [MovieDTO]{
        var movieDTOList = [MovieDTO]()
        
        movieEntityList.forEach{ movieEntity in
            movieDTOList.append(movieEntityToDTO(movieEntity: movieEntity))
        }
        
        return movieDTOList
    }
    
    public func findAllFromDevice(completion: @escaping ([MovieDTO]) -> ()) throws{
        
        let movieEntityList = try MovieRepository.shared().findAll()
        
        let movieDTOList = movieEntityListToDTOList(movieEntityList: movieEntityList)
        
        completion(movieDTOList)
    }
    
    public func findOneFromDevice(by id: Int, completion: @escaping (MovieDTO) -> ()) throws{
        
        let movieEntity = try MovieRepository.shared().findOne(by: id)
        
        let movieDTO = movieEntityToDTO(movieEntity: movieEntity!)
        
        completion(movieDTO)
    }
    
    public func saveOnDevice(movie : MovieDTO) throws{
        try MovieRepository.shared().save(movie: movie)
    }
    
    public func removeMovieFromDevice(id : Int) throws{
        try MovieRepository.shared().remove(id: id)
    }
    

    public func findAllFromAPI(query: String, completion: @escaping (MoviePageDTO) -> ()) -> URLSessionDataTask{
        let moviedbAPI = MoviedbAPI()
        
        let task = moviedbAPI.getMovies(query: query){ data, response, error in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let moviePage = try decoder.decode(MoviePageDTO.self, from: data)
                
                    completion(moviePage)
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        
        return task
    }
    
    public func getPosterFromAPI(path: String, quality: Quality, completion: @escaping (UIImage) -> ()) -> URLSessionDataTask{
        let moviedbAPI = MoviedbAPI()
        
        let task = moviedbAPI.getPoster(path: path, quality: quality) { data, response, error in
            if let image = UIImage(data: data!){
                completion(image)
            }
        }
        
        return task
    }
}
