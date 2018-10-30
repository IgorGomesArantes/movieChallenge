//
//  DataBaseViewModelProtocol.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 30/10/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

protocol DataBaseViewModelProtocol {
    var repository: RepositoryProtocol { get }
    var onChangeDataBase: ((MovieState.Change) -> ())? { get set }
    func remove(movieId: Int)
    func save(movie: MovieDTO)
    func changeDataBase(change: MovieState.Change)
}

extension DataBaseViewModelProtocol {
    func remove(movieId: Int) {
        do{
            try repository.removeMovie(id: movieId)
            self.changeDataBase(change: MovieState.Change.success)
        }catch let error{
            print("Erro ao remover: ", error)
            self.changeDataBase(change: MovieState.Change.error)
        }
    }
    
    func save( movie: MovieDTO){
        do{
            try repository.saveMovie(movie: movie)
            self.changeDataBase(change: MovieState.Change.success)
        }catch let error{
            print("Erro ao salvar: ", error)
            self.changeDataBase(change: MovieState.Change.error)
        }
    }
}

