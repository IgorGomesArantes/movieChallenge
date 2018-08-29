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
    
    //TODO Alterar para entity
    public func save(movie: MovieDTO) throws {
        let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: context)
        
        movieEntity.setValue(movie.id, forKey: "id")
        movieEntity.setValue(movie.title, forKey: "title")
        movieEntity.setValue(movie.vote_count, forKey: "vote_count")
        movieEntity.setValue(movie.vote_average, forKey: "vote_average")
        movieEntity.setValue(movie.overview, forKey: "overview")
        movieEntity.setValue(movie.poster_path, forKey: "poster_path")
        
        try context.save()
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
    
    public func remove(movieEntity: MovieEntity) throws {
        context.delete(movieEntity as NSManagedObject)
        try context.save()
    }
    
    public func remove(id: Int) throws {
        
        if let movieEntity = try findOne(by: id){
            try remove(movieEntity: movieEntity)
        }
    }
    
    public func findOne(by id: Int) throws -> MovieEntity?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        request.predicate = NSPredicate(format: "id = " + String(id))
        
        let fetchedMovies = try context.fetch(request) as! [MovieEntity]
        
        if(fetchedMovies.count > 0){
            return fetchedMovies[0]
        }else{
            throw NotFoundError.runtimeError("Filme nao encontrado")
        }
    }
    
    public func findAll() throws -> [MovieEntity]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        return try context.fetch(request) as! [MovieEntity]
    }
}











