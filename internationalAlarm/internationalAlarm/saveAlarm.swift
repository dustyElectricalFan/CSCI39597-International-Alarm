//
//  saveAlarm.swift
//  internationalAlarm
//
//  Created by essdessder on 5/14/20.
//  Copyright © 2020 essdessder. All rights reserved.
//
//  Created by Yusen Chen. essdessder is my mac name/ online handle

import Foundation
import CoreData

class saveAlarm{
    
    private init() {}
    static var context: NSManagedObjectContext {return persistentContainer.viewContext}
    
    static var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "DataModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()


       static func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
}
