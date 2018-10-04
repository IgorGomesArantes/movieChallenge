//
//  MovieRepository.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 28/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MovieRepository{

    //MARK:- Private constants
    private let appDelegate : AppDelegate
    private let context : NSManagedObjectContext
    
    //MARK:- Singleton implementation
    private static var sharedInstance: MovieRepository = {
        let instance = MovieRepository()
        
        return instance
    }()

    private init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    class func shared() -> MovieRepository{
        return sharedInstance
    }
    
    //MARK:- Private movie methods
    private func findOneMovieEntity(by id: Int) throws -> MovieEntity{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")

        request.predicate = NSPredicate(format: "id = " + String(id))
        
        let fetchedMovies = try context.fetch(request) as! [MovieEntity]
        
        if let movieEntity = fetchedMovies.first {
            return movieEntity
        }else{
            throw NotFoundError.runtimeError("Filme nao encontrado")
        }
    }

    //MARK:- Public movie methods
    public func saveMovie(movie: MovieDTO) throws {
        
        let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: context) as! MovieEntity
        
        for genre in movie.genres!{
            do{
                if let category = try getCategory(by: genre.id!){
                    category.addToMoviesOfCategory(movieEntity)
                }
            }catch{
                let categotyEntity = NSEntityDescription.insertNewObject(forEntityName: "CategoryEntity", into: context) as! CategoryEntity
                
                categotyEntity.setValue(genre.id, forKey: "id")
                categotyEntity.setValue(genre.name, forKey: "name")
                
                categotyEntity.addToMoviesOfCategory(movieEntity)
            }
        }
        
        movieEntity.setValue(movie.id, forKey: "id")
        movieEntity.setValue(movie.title, forKey: "title")
        movieEntity.setValue(movie.vote_count, forKey: "vote_count")
        movieEntity.setValue(movie.vote_average, forKey: "vote_average")
        movieEntity.setValue(movie.overview, forKey: "overview")
        movieEntity.setValue(movie.poster_path, forKey: "poster_path")
        movieEntity.setValue(movie.release_date, forKey: "release_date")
        movieEntity.setValue(movie.runtime, forKey: "runtime")
        movieEntity.setValue(Date(), forKey: "creation_date")
        
        if movie.poster != nil{
            movieEntity.setValue(movie.poster!, forKey: "poster")
        }
        
        try context.save()
    }
    
    public func getAllMovies() throws -> [MovieDTO]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        let movieEntityList = try context.fetch(request) as! [MovieEntity]
        
        let movieDTOList = MovieHelper.movieEntityListToDTOList(movieEntityList: movieEntityList)
        
        return movieDTOList
    }
    
    public func getMovie(by id: Int) throws -> MovieDTO{

        let movieEntity = try findOneMovieEntity(by: id)
        
        var movieDTO = MovieHelper.movieEntityToDTO(movieEntity: movieEntity)
        //movieDTO.favorite = true
        
        return movieDTO
    }
    
    public func removeMovie(id: Int) throws {
        
        let movieEntity = try findOneMovieEntity(by: id)
        
        context.delete(movieEntity as NSManagedObject)
        
        if let array = movieEntity.categoriesOfMovie{
            let categories = Array(array) as! [CategoryEntity]
            
            for category in categories{
                do{
                    if let categoryEntity = try getCategory(by: Int(category.id)){
                        let categoryDTO = MovieHelper.categoryEntityToDTO(categoryEntity: categoryEntity)
                        
                        if categoryDTO.movies?.count == 0{
                            context.delete(categoryEntity)
                        }
                    }
                }catch{
                    print("Erro ao remover categoria")
                }
            }
        }
        
        try context.save()
    }
    
    //MARK:- Public category methods
    public func getCategory(by id: Int) throws -> CategoryEntity?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        
        request.predicate = NSPredicate(format: "id = " + String(id))
        
        let fetchedCategories = try context.fetch(request) as! [CategoryEntity]
        
        if let category = fetchedCategories.first{
            return category
        }else{
            throw NotFoundError.runtimeError("Filme nao encontrado")
        }
    }
    
    public func getAllCategories() throws -> [CategoryDTO]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        let categoryEntityList = try context.fetch(request) as! [CategoryEntity]
        let categoryDTOList = MovieHelper.categoryEntityListToDTOList(categoryEntityList: categoryEntityList)
        
        return categoryDTOList
    }
}
