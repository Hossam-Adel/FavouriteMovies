//
//  DBmgr.swift
//  Movies
//
//  Created by Sayed Abdo on 4/13/18.
//  Copyright © 2018 JETS. All rights reserved.
//
import UIKit
import Foundation
import CoreData
class DBmgr: NSObject {
    func saveData(name:String?,year:String?,rating:Float?,image:String?,overview:String?,id:Int?,favourite:Int?){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: managedContext)
        let movie = NSManagedObject(entity: entity!, insertInto: managedContext)
        movie.setValue(name!, forKey: "title")
        movie.setValue(Float(rating!), forKey: "rating")
        movie.setValue(year!, forKey: "year")
        movie.setValue(image!, forKey: "image")
        movie.setValue(id!, forKey: "id")
        movie.setValue(Int(favourite!), forKey: "favourite")
        movie.setValue(overview!, forKey: "overview")
        do{
            try managedContext.save()
        }catch let error as NSError{
            print(error)
        }
    }
    func getData()->[NSManagedObject]{
        var movie : [NSManagedObject] = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        //let mypredicate = NSPredicate(format: "title == %@", title!)
        //  fetchrequest.predicate = mypredicate
        do{
            movie  = try managedContext.fetch(fetchrequest) as! [NSManagedObject]
            
        }catch let error as NSError{
            print(error)
        }
        return movie
    }
    func deleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
        try managedContext.execute(deleteRequest)
        try managedContext.save()
        }catch let error as NSError{
            print(error)
        }
    }
    func selectFavourites()->[NSManagedObject]{
        var movies : [NSManagedObject] = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let mypredicate = NSPredicate(format: "favourite == 1")
          fetchrequest.predicate = mypredicate
        do{
            movies  = try managedContext.fetch(fetchrequest) as! [NSManagedObject]
            
        }catch let error as NSError{
            print(error)
        
        
        }
        return movies
    }
    func addorRemoveFavourites(title : String)->Bool{
        var movie : [NSManagedObject] = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let mypredicate = NSPredicate(format: "title == %@", title)
          fetchrequest.predicate = mypredicate
        do{
            movie  = try managedContext.fetch(fetchrequest) as! [NSManagedObject]
            
        }catch let error as NSError{
            print(error)
        }
        
        if(movie.count > 0){
            if movie[0].value(forKey:"favourite") as! Int == 1 {
                saveData(name: movie[0].value(forKey: "title") as? String,year:movie[0].value(forKey: "year") as? String,rating:movie[0].value(forKey: "rating") as? Float,image:movie[0].value(forKey: "image") as? String,overview:movie[0].value(forKey: "overview") as? String,id:movie[0].value(forKey: "id") as? Int,favourite:0)
                return false
            }
            if movie[0].value(forKey: "favourite") as! Int == 0{
                saveData(name: movie[0].value(forKey: "title") as? String,year:movie[0].value(forKey: "year") as? String,rating:movie[0].value(forKey: "rating") as? Float,image:movie[0].value(forKey: "image") as? String,overview:movie[0].value(forKey: "overview") as? String,id:movie[0].value(forKey: "id") as? Int,favourite:1)
                return true
            }
        }
            
    
            
         else {
            print("unable to fetch or create list")
        }
        return false
    }
    
    
}

