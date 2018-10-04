//
//  FavoriteViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 03/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class FavoriteViewModel: MovieViewModel, DataBaseViewModel, ScrollViewModel{
    
    //MARK:- Private variables
    private var allMoviesList: [MovieDTO]!
    private var categoryList: [CategoryDTO]!
    private(set) var selectedList: [MovieDTO]!
    private(set) var selectedCategoryName: String?
    
    //MARK:- Public variables
    var selectedCategoryIndex: Int?{
        didSet{
            reload()
        }
    }
    
    //MARK:- Private methods
    private func setSelectedList(index: Int){
        if selectedCategoryIndex == 0{
            selectedCategoryName = "Todos os filmes"
            selectedList = allMoviesList
            
            
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
    }
    
    private func setMovieLists(){
        do{
            allMoviesList = try MovieRepository.shared().getAllMovies()
            categoryList = try MovieRepository.shared().getAllCategories()
            
            categoryList.sort(by: { $0.name! < $1.name! })
            allMoviesList.sort(by: { $0.title! < $1.title! })
            
            if(categoryList.count > 0){
                for i  in 0...categoryList.count - 1{
                    if categoryList[i].movies != nil{
                        categoryList[i].movies?.sort(by: { $0.title! < $1.title! })
                    }
                }
            }
            
        }catch let error{
            print("Erro ao carregar dados: ", error)
        }
    }
    
    //MARK:- Public methods
    init(onChange: @escaping ((MovieState.Change) -> ()), onChangeDataBase: @escaping ((MovieState.Change) -> ())){
        self.onChange = onChange
        self.onChangeDataBase = onChangeDataBase
        self.setMovieLists()
        selectedList = allMoviesList
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
    
    //MARK:- MovieViewModel methods and variables
    var state: MovieState = MovieState()
    var onChange: ((MovieState.Change) -> ())
    
    func reload() {
        setSelectedList(index: selectedCategoryIndex!)
        
        onChange(MovieState.Change.success)
    }
    
    //MARK:- DataBaseViewModel methods and variables
    var onChangeDataBase: ((MovieState.Change) -> ())
    
    func changeDataBase(change: MovieState.Change) {
        setMovieLists()
        
        setSelectedList(index: selectedCategoryIndex!)
        
        onChangeDataBase(change)
    }
    
    //MARK:- ScrollViewModel methods and variables
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return selectedList.count
    }
    
    func movie(row: Int, section: Int) -> MovieDTO {
        return MovieDTO()
    }
}
