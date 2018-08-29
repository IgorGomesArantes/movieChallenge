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
    
    //Corrigir Funcao
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
        
        return movieDTO
    }
    
    private func movieDTOListToEntityList(movieDTOList: [MovieDTO]) -> [MovieEntity]{
        var movieEntityList = [MovieEntity]()
        
        movieDTOList.forEach{ movieDTO in
            movieEntityList.append(movieDTOToEntity(movieDTO: movieDTO))
        }
        
        return movieEntityList
    }
    
    public func findAllFromDevice(completion: @escaping ([MovieEntity]) -> ()) throws{
        
        let movies = try MovieRepository.shared().findAll()
        
        completion(movies)
    }
    
    public func findOneFromDevice(by id: Int, completion: @escaping (MovieEntity) -> ()) throws{
        
        let movie = try MovieRepository.shared().findOne(by: id)
        
        completion(movie!)
    }
    
    public func saveOnDevice(movieEntity : MovieEntity) throws{
        try MovieRepository.shared().save(movie: movieEntity)
    }
    
    public func removeMovieFromDevice(movieEntity : MovieEntity) throws{
        try MovieRepository.shared().remove(movieEntity: movieEntity)
    }
    
    //TODO Paginavel
    public func findAllFromAPI(query: String, completion: @escaping ([MovieEntity]) -> ()){
        let moviedbAPI = MoviedbAPI()
        
        _ = moviedbAPI.getMovies(query: query){ data, response, error in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let moviePage = try decoder.decode(MoviePageDTO.self, from: data)
                    
                    let movieEntityList = self.movieDTOListToEntityList(movieDTOList: moviePage.results)
                    
                    completion(movieEntityList)
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
    }
    
    public func getPosterFromAPI(posterPath: String, completion: @escaping (UIImage) -> ()){
        let moviedbAPI = MoviedbAPI()
        
        _ = moviedbAPI.getPoster(path: posterPath, quality: Quality.high) { data, response, error in
            if let image = UIImage(data: data!){
                completion(image)
            }
        }
    }
}
