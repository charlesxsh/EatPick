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
    public static func newObjectWithContext()->Favorite?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            log.error("Cannot get app delegate")
            return nil
        }
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)
        let newFavorite = Favorite(entity: entity!, insertInto: managedContext)
        return newFavorite
    }
    
    public static func newObject(WithYelpBusinessJson businessObject:[String:Any])->Favorite?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            log.error("Cannot get app delegate")
            return nil
        }
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)
        let newFavorite = Favorite(entity: entity!, insertInto: nil)
        let locationObject = businessObject["location"] as! [String:AnyObject]
        let address = locationObject.getString(By: "address1")
        let city = locationObject.getString(By: "city")
        let state = locationObject.getString(By: "state")
        newFavorite.address = "\(address), \(city), \(state)"
        newFavorite.name = businessObject.getString(By: "name")
        newFavorite.businessId = businessObject.getString(By: "id")
        
        newFavorite.photoUrl =  businessObject.getString(By: "image_url")
        let coordinates = businessObject["coordinates"] as! [String:AnyObject]
        newFavorite.latitude = coordinates["latitude"] as! Float
        newFavorite.longitude = coordinates["longitude"] as! Float
        
        newFavorite.phone = businessObject.getString(By: "phone")
        
        let categories = businessObject["categories"] as! [[String:String]]
        var cateString = ""
        for c in categories{
            cateString.append("\(c["title"]!) & ")
        }
        cateString.remove(at: cateString.index(cateString.endIndex, offsetBy: -2))
        newFavorite.category =  cateString
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
        let managedContext = appDelegate.managedObjectContext
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
            appDelegate.managedObjectContext
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
