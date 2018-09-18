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
    
    //MARK:- Private variables
    private var categoryList = [CategoryDTO]()
    
    //MARK:- View variables
    @IBOutlet var favoriteTable: UITableView!
    
    
    //MARK:- Primitive methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do{
            categoryList = try MovieRepository.shared().getAllCategories()
            favoriteTable.reloadData()
        }catch let exception{
            print("Erro", exception)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        super.numberOfSections(in: tableView)
        
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableViewCell

        cell.setUp(category: categoryList[indexPath.section])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        super.tableView(tableView, viewForHeaderInSection: section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteHeaderCell") as! FavoriteHeaderTableViewCell

        cell.setUp(categoryName: categoryList[section].name, numberOfMovies: categoryList[section].movies?.count)
        
        return cell
    }
}
