//
//  RepositoryEntity.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/6/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Foundation
import CoreData

// MARK: CoreData Class
@objc(RepositoryEntity)
public class RepositoryEntity: NSManagedObject {
    
    // MARK: Init
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init() {
        let context = CoreDataStack.shared.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "RepositoryEntity", in: context)
        self.init(entity: entity!, insertInto: context)
    }
    
    // MARK: Set with view model
    convenience init(with repository: RepositoryViewModel) {
        self.init()
        
        if let id = repository.id {
            self.id = Int32(id)
        }
        
        self.name = repository.name
        self.body_description = repository.description
        self.owner_username = repository.ownerUsername
        self.owner_avatar_url = repository.ownerAvatarUrl
        self.forks_count = repository.forksCount
        self.stars_count = repository.starsCount
        self.isFavorite = repository.isFavorite
    }
    
    // MARK: Methods
    class func fetchAll(favorites: Bool? = nil) -> [RepositoryEntity]? {
        var predicate: NSPredicate?
        var stringPredicate = ""
        if let favorites = favorites {
            if favorites {
                stringPredicate = "YES"
            } else {
                stringPredicate = "NO"
            }
            predicate = NSPredicate(format: "favorites == \(stringPredicate)")
        }
        
        var sort = [NSSortDescriptor]()
        sort.append(NSSortDescriptor(key: "id", ascending: false))
        
        let repositories = try? CoreDataStack.shared.managedObjectContext.fetchObjects(RepositoryEntity.self, sortBy: sort, predicate: predicate)
        return repositories
    }
    
    func saveToStore() {
        try? CoreDataStack.shared.saveContext()
    }
}

// MARK: Properties
extension RepositoryEntity {
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var body_description: String?
    @NSManaged public var owner_username: String?
    @NSManaged public var owner_avatar_url: String?
    @NSManaged public var forks_count: String?
    @NSManaged public var stars_count: String?
    @NSManaged public var isFavorite: Bool
}
