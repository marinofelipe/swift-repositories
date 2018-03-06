//
//  CoreDataStack.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/6/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import CoreData

final class CoreDataStack {
    
    // MARK: Properties
    static let shared = CoreDataStack()
    private let modelName: String
    
    // MARK: Core Data Stack Setup
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    // MARK: Core Data Stack Setup
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        repeat {
            let generalPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            let fileManager = FileManager.default
            let storeName = "\(self.modelName).sqlite"
            
            let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
            
            do {
                try generalPersistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                         configurationName: nil,
                                                                         at: persistentStoreURL,
                                                                         options: nil)
                return generalPersistentStoreCoordinator
            } catch {
                //TODO: Treat migration and versioning
                try? fileManager.removeItem(at: persistentStoreURL) // <- deleting existing so we can recreate without unninstalling
            }
        } while true
    }()
    
    // MARK: Init
    init() {
        //data model name
        self.modelName = "SwiftRepositories"
    }
    
    // MARK: Methods
    internal func saveContext() throws {
        do {
            try managedObjectContext.save()
        } catch let error {
            throw error
        }
    }
    
    internal func rollbackContext() {
        managedObjectContext.rollback()
    }
}

// MARK: NSManagedObjectContext
extension NSManagedObjectContext {
    func fetchObjects <T: NSManagedObject>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) throws -> [T] {
        
        var request: NSFetchRequest<T>
        
        let entityName = String(describing: entityClass)
        request = NSFetchRequest(entityName: entityName)
        
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.sortDescriptors = sortBy
        
        let fetchedResult = try self.fetch(request)
        return fetchedResult
    }
}
