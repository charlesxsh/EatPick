//
//  FavoriteExtension.swift
//  EatPick
//
//  Created by Shihao Xia on 1/9/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import CoreData

extension Favorite{
    public static func newObject()->Favorite?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            log.error("Cannot get app delegate")
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)
        let newFavorite = Favorite(entity: entity!, insertInto: managedContext)
        return newFavorite
    }
    
    func delete(){
        self.managedObjectContext!.delete(self)
    }
    
    public static func isExistObject(ById businessId:String)->Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            log.error("Cannot get app delegate")
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "businessId == %@", businessId)
        fetchRequest.fetchLimit = 1
        do{
            let count = try managedContext.count(for: fetchRequest)
            if count == 0 {return false}
            else {return true}
        }catch let error{
            log.error(error.localizedDescription)
        }
        return false
    }
    static func randomPickOne()->Favorite?{
        var favorites:[Favorite]?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            log.error("Cannot get app delegate")
            return nil
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<Favorite>(entityName: "Favorite")
        do {
            favorites = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            log.error("Could not fetch. \(error), \(error.userInfo)")
        }
        return favorites?.randomElement


    }
}
