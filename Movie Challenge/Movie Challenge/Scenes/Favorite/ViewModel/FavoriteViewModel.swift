//
//  FavoriteViewModel.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 03/10/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation

class FavoriteViewModel: ViewModelProtocol, DataBaseViewModelProtocol, ScrollViewModelProtocol{
    
    //MARK:- Private variables
    private var allMoviesList: [MovieDTO]!
    private var categoryList: [CategoryDTO]!
    private(set) var selectedList: [MovieDTO]!
    private(set) var selectedCategoryName: String
    internal var repository: RepositoryProtocol
    
    //MARK:- Public variables
    var selectedCategoryIndex: Int?{
        didSet{
            reload()
        }
    }
    
    //MARK:- Private methods
    private func setMovieLists(){
        do{
            allMoviesList = try repository.getAllMovies()
            categoryList = try repository.getAllCategories()
            
            if(categoryList.count > 0){
                categoryList.sort(by: { $0.name! < $1.name! })
                allMoviesList.sort(by: { $0.title! < $1.title! })
                
                for i in 0...categoryList.count - 1{
                    if categoryList[i].movies != nil{
                        categoryList[i].movies?.sort(by: { $0.title! < $1.title! })
                    }
                }
                
                var allCategory = CategoryDTO()
                allCategory.id = -1
                allCategory.name = "Todos os filmes"
                allCategory.movies = allMoviesList
                
                categoryList.insert(allCategory, at: 0)
            }
        }catch{
            onChangeDataBase!(MovieState.Change.error)
        }
    }
    
    private func setSelectedList(index: Int){
        if categoryList.count > index{
            selectedCategoryName = categoryList[index].name ?? "Genero"
            selectedList = categoryList[index].movies
            onChange!(MovieState.Change.success)
        }else{
            selectedList = [MovieDTO]()
            selectedCategoryName = "Vazio"
            onChange!(MovieState.Change.emptyResult)
        }
    }
    
    //MARK:- Public methods
    init(repository: RepositoryProtocol, onChange: @escaping ((MovieState.Change) -> ()), onChangeDataBase: @escaping ((MovieState.Change) -> ())){
        selectedCategoryName = "Genero"
        self.onChange = onChange
        self.onChangeDataBase = onChangeDataBase
        self.repository = repository
        setMovieLists()
    }
    
    func numberOfCategories() -> Int{
        return categoryList.count
    }
    
    func getCategoryOptionViewModel(index: Int) -> CategoryOptionViewModel{
        let categoryOptionViewModel = CategoryOptionViewModel(category: categoryList[index])
        
        return categoryOptionViewModel
    }
    
    //TODO:- Corrigir
    func getDetailViewModel(movieId: Int) -> DetailViewModel{
        let detailViewModel = DetailViewModel(movieId: movieId, service: HTTPService(), repository: MovieRepository())
        
        return detailViewModel
    }
    
    func getFavoriteCellViewModel(delegate: FavoriteCellViewModelDelegate, index: Int) -> FavoriteCellViewModel{
        return FavoriteCellViewModel(delegate: delegate, movie: selectedList[index])
    }
    
    //MARK:- MovieViewModel methods and variables
    var state: MovieState = MovieState()
    var onChange: ((MovieState.Change) -> ())?
    
    func reload() {
        if selectedCategoryIndex == nil{
            setMovieLists()
            setSelectedList(index: 0)
        }else{
            setSelectedList(index: selectedCategoryIndex!)
        }
    }
    
    //MARK:- DataBaseViewModel methods and variables
    var onChangeDataBase: ((MovieState.Change) -> ())?
    
    func changeDataBase(change: MovieState.Change) {
        switch change {
        case .success:
            selectedCategoryIndex = nil
            break
        default:
            onChangeDataBase!(MovieState.Change.error)
        }
    }
    
    //MARK:- ScrollViewModel methods and variables
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return selectedList.count
    }
    
    func movie(row: Int, section: Int = 1) -> MovieDTO {
        return selectedList[row]
    }
}
