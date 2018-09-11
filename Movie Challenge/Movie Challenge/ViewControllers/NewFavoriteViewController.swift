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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableViewCell
    
        return cell
    }
}
