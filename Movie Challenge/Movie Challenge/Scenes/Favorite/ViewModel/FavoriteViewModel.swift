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
    
    //MARK:- Public variables
    var repository: RepositoryProtocol
    
    var onChange: ((MovieState.Change) -> ())?
    var onChangeDataBase: ((MovieState.Change) -> ())?
    
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
                allCategory.name = NSLocalizedString("All movies", comment: "")
                allCategory.movies = allMoviesList
                
                categoryList.insert(allCategory, at: 0)
            }
            
            setSelectedList(index: 0)
            
        } catch {
            onChangeDataBase?(.error)
        }
    }
    
    private func setSelectedList(index: Int){
        if categoryList.count > index{
            selectedCategoryName = categoryList[index].name ?? NSLocalizedString("Genre", comment: "")
            selectedList = categoryList[index].movies
            onChange?(.success)
        }else{
            selectedList = [MovieDTO]()
            selectedCategoryName = NSLocalizedString("Empty", comment: "")
            onChange?(.emptyResult)
        }
    }
    
    //MARK:- Public methods
    init(repository: RepositoryProtocol){
        selectedCategoryName = NSLocalizedString("Genre", comment: "")
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
        let detailViewModel = DetailViewModel(movieId: movieId, service: HTTPMovieService(), repository: MovieRepository())
        
        return detailViewModel
    }
    
    func getFavoriteCellViewModel(delegate: FavoriteCellViewModelDelegate, index: Int) -> FavoriteCellViewModel{
        return FavoriteCellViewModel(delegate: delegate, movie: selectedList[index])
    }
    
    //MARK:- MovieViewModel methods
    func reload() {
        if selectedCategoryIndex == nil{
            setMovieLists()
        } else {
            setSelectedList(index: selectedCategoryIndex!)
        }
    }
    
    //MARK:- DataBaseViewModel methods
    func changeDataBase(change: MovieState.Change) {
        switch change {
        case .success:
            selectedCategoryIndex = nil
            break
        default:
            onChangeDataBase?(MovieState.Change.error)
        }
    }
    
    //MARK:- ScrollViewModel methods
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
