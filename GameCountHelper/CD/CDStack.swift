//
//  CDStack.swift
//  GameCountHelper
//
//  Created by Vlad on 5/9/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation
import CoreData

class CDStack {
    
    let cryptoString = "GameCountHelper"
    
    init() {
        let modelURL = Bundle.main.url(forResource: cryptoString, withExtension: "momd")!
        managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        persistentContainer = NSPersistentContainer(name: cryptoString, managedObjectModel: managedObjectModel)
        
        
        print("persistentContainer.persistentStoreDescriptions: \(persistentContainer.persistentStoreDescriptions)")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    
    
    private let managedObjectModel: NSManagedObjectModel
    


    func viewContext() -> NSManagedObjectContext  {
        return persistentContainer.viewContext
    }
    
    func save() {
        viewContext().saveIfNeed()
    }

    let persistentContainer: NSPersistentContainer
    
}

extension NSManagedObjectContext {
    func saveIfNeed () {
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                print("Can't save context. Error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

protocol CoreDataEntity: NSManagedObject {
    static func entityName() -> String
}

extension CoreDataEntity {
    
    init(entityName: String, context: NSManagedObjectContext)
    {
        self.init(entity: NSEntityDescription.entity(forEntityName: entityName, in: context)!, insertInto: context)
    }
    
    static func fetchItems(predicate: NSPredicate, context: NSManagedObjectContext) -> [Self]? {
        let fetchRequest = self.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let objects = try context.fetch(fetchRequest)
            return (objects as? [Self])
        } catch let error {
            print(error)
        }
        return nil
    }
    
    static func fetch(predicate: NSPredicate, context: NSManagedObjectContext) -> Self? {
        let fetchRequest = self.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.count > 0 {
                return objects.first as? Self
            }
        } catch let error {
            print(error)
        }
        return nil
    }
    
    static func fetchOrCreate(predicate: NSPredicate, context: NSManagedObjectContext) -> Self {
        if let object = fetch(predicate: predicate, context: context) {
            return object
        }
        return createObject(context: context)
    }
    
    public static func createObject(context: NSManagedObjectContext) -> Self {
        let obj = NSEntityDescription.insertNewObject(forEntityName: entityName() , into: context) as! Self
        return obj
    }
    
    public static func entityRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName())
    }
    
    public static func fetchAllInstances(in context: NSManagedObjectContext) -> [Self] {
        let request = fetchRequest()
        do {
            guard let entities = try context.fetch(request) as? [Self] else {return [Self]()}
            return entities
        }
        catch let error {
            print("Recieving error when fetching all instances of \(entityName()). Error - \(error)")
            return [Self]()
        }
    }
}
