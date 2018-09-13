//
//  NewFavoriteViewController.swift
//  Movie Challenge
//
//  Created by Igor Gomes Arantes on 11/09/2018.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController : UITableViewController{
    
    @IBOutlet var favoriteTableView: UITableView!
    
    var categoryList = [CategoryDTO]()
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            categoryList = try MovieRepository.shared().getAllCategories()
            favoriteTableView.reloadData()
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

        cell.setUp(category: categoryList[indexPath.section])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteHeaderCell") as! FavoriteHeaderTableViewCell

        cell.setUp(categoryName: categoryList[section].name, numberOfMovies: categoryList[section].movies?.count)
        
        return cell
    }
}
