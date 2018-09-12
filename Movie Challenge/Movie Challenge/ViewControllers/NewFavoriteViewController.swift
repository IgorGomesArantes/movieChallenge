//
//  NewFavoriteViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 11/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class NewFavoriteViewController : UITableViewController{
    
    @IBOutlet var favoriteTableView: UITableView!
    
    var categoryList: [CategoryDTO]!
    
    override func viewDidLoad() {
        do{
            try MovieService.shared().findAllCategoriesFromDevice(){ categoryList in
                self.categoryList = categoryList
            }
        }catch let exception{
            print("Erro", exception)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableViewCell

        cell.category = categoryList[indexPath.section]
        //cell.favoriteCollectionView.reloadData()
        cell.setUp()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteHeaderCell") as! FavoriteHeaderTableViewCell

        let numberOfMovies: Int = categoryList[section].movies?.count ?? 0
        
        cell.categoryLabelView.text = categoryList[section].name
        cell.numberOfMoviesLabelView.text = "(" + String(numberOfMovies) + ")"
        
        return cell
    }
}
