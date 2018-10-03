//
//  FavoriteViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 03/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class FavoriteViewModel: MovieViewModel, BaseFavoriteViewModel, BaseScrollViewModel{
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return selectedList.count
    }
    
    func movie(row: Int, section: Int) -> MovieDTO {
        return MovieDTO()
    }
    
    func numberOfCategories() -> Int{
        return categoryList.count + 1
    }
    
    //TODO:- Adicionar categoria 0(Todos) na lista de categorias
    func category(index: Int) -> CategoryDTO{
        if index == 0{
            var category = CategoryDTO()
            category.name = "Todos"
            
            return category
        }
        
        return categoryList[index - 1]
    }
    
    
    var state: MovieState = MovieState()
    private var allMovieList: [MovieDTO]!
    private var categoryList: [CategoryDTO]!
    private(set) var selectedList: [MovieDTO]!
    private(set) var selectedCategoryName: String?
    var selectedCategoryIndex: Int?{
        didSet{
            reload()
        }
    }
    
    var onChange: ((MovieState.Change) -> ())
    
    init(onChange: @escaping ((MovieState.Change) -> ())){
        self.onChange = onChange
        
        setMovieLists()
    }
    
    func reload() {
        if selectedCategoryIndex == 0{
            selectedCategoryName = "Todos os filmes"
            selectedList = allMovieList
            
            
        }else{
            
            if let categoryName = categoryList[selectedCategoryIndex! - 1].name{
                selectedCategoryName = categoryName
            }
            
            if let movies = categoryList[selectedCategoryIndex! - 1].movies{
                selectedList = movies
            }else{
                selectedList = [MovieDTO]()
            }
        }
        
        onChange(MovieState.Change.success)
    }
    
    private func setMovieLists(){
        do{
            allMovieList = try MovieRepository.shared().getAllMovies()
            categoryList = try MovieRepository.shared().getAllCategories()
            
//            categoryList.sort(by: { $0.name! < $1.name! })
//            allMovieList.sort(by: { $0.title! < $1.title! })
//
//            if(categoryList.count > 0){
//                for i  in 0...categoryList.count - 1{
//                    if categoryList[i].movies != nil{
//                        categoryList[i].movies?.sort(by: { $0.title! < $1.title! })
//                    }
//                }
//            }
            
            selectedList = allMovieList

        }catch let error{
            print("Erro ao carregar dados: ", error)
        }
    }
    
}
