//
//  FavoriteViewController.swift
//  Movie Challenge
//
//  Created by igor gomes arantes on 28/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import UIKit
import CoreData

class FavoriteViewController : UITableViewController{
    
    override func viewDidAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do{
            
            let movies = try context.fetch(request)
            
            if(movies.count > 0){
                print("Aqui")
                print(movies)
            }else{
                print("Entidade vazia")
            }
            
        }catch{
            print("Erro ao ler dados")
        }
    }
    
}
