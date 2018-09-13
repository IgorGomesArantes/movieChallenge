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

enum NotFoundError: Error {
    case runtimeError(String)
}

class MovieRepository{
    
    //private static var instance : MovieRepository!
    private let appDelegate : AppDelegate
    private let context : NSManagedObjectContext
    
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
    


    public func save(movie: MovieEntity) throws {
        let movieDescription = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: context)
        
        movieDescription.setValue(movie.id, forKey: "id")
        movieDescription.setValue(movie.title, forKey: "title")
        movieDescription.setValue(movie.vote_count, forKey: "vote_count")
        movieDescription.setValue(movie.vote_average, forKey: "vote_average")
        movieDescription.setValue(movie.overview, forKey: "overview")
        movieDescription.setValue(movie.poster_path, forKey: "poster_path")
        
        try context.save()
    }
    
    public func findAll() throws -> [MovieEntity]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        return try context.fetch(request) as! [MovieEntity]
    }
    
    
    private func findAllCategories() throws -> [CategoryEntity]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        
        return try context.fetch(request) as! [CategoryEntity]
    }
    
    //----------
    
    public func findOneMovieEntity(by id: Int) throws -> MovieEntity{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        request.predicate = NSPredicate(format: "id = " + String(id))
        
        let fetchedMovies = try context.fetch(request) as! [MovieEntity]
        
        if let movieEntity = fetchedMovies.first {
            return movieEntity
        }else{
            throw NotFoundError.runtimeError("Filme nao encontrado")
        }
    }
    
    public func findOneCategory(by id: Int) throws -> CategoryEntity?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        
        request.predicate = NSPredicate(format: "id = " + String(id))
        
        let fetchedCategories = try context.fetch(request) as! [CategoryEntity]
        
        if let category = fetchedCategories.first{
            return category
        }else{
            throw NotFoundError.runtimeError("Filme nao encontrado")
        }
    }
    
    public func getAll() throws -> [MovieDTO]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        let movieEntityList = try context.fetch(request) as! [MovieEntity]
        
        let movieDTOList = MovieHelper.movieEntityListToDTOList(movieEntityList: movieEntityList)
        
        return movieDTOList
    }
    
    public func getOne(by id: Int) throws -> MovieDTO{
        
        let movieEntity = try findOneMovieEntity(by: id)
        
        let movieDTO = MovieHelper.movieEntityToDTO(movieEntity: movieEntity)
        
        return movieDTO
    }
    
    public func save(movie: MovieDTO) throws {
        
        let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: context) as! MovieEntity
        
        for genre in movie.genres!{
            do{
                let category = try findOneCategory(by: genre.id!) as! CategoryEntity
                
                category.addToMoviesOfCategory(movieEntity)
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
        
        if(movie.poster != nil){
            movieEntity.setValue(movie.poster!, forKey: "poster")
        }
        
        try context.save()
    }
    
    public func remove(movieEntity: MovieEntity) throws {
        context.delete(movieEntity as NSManagedObject)
        try context.save()
    }
    
    public func remove(id: Int) throws {
        
        let movieEntity = try findOneMovieEntity(by: id)
        
        try remove(movieEntity: movieEntity)
    }
    
    //----
    
    public func getAllCategories() throws -> [CategoryDTO]{
        
        let categoryEntityList = try MovieRepository.shared().findAllCategories()
        
        let categoryDTOList = MovieHelper.categoryEntityListToDTOList(categoryEntityList: categoryEntityList)
        
        return categoryDTOList
    }
}











