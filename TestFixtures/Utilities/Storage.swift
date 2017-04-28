//
//  CoreDataStack.swift
//  EasyMapping
//
//  Created by Denys Telezhkin on 23.04.17.
//  Copyright © 2017 EasyMapping. All rights reserved.
//

import Foundation

//      CoreData stack taken from
//      https://gist.github.com/avdyushin/b67e4524edcfb1aec47605da1a4bea7a

import CoreData

/// NSPersistentStoreCoordinator extension
extension NSPersistentStoreCoordinator {
    
    /// NSPersistentStoreCoordinator error types
    public enum CoordinatorError: Error {
        /// .momd file not found
        case modelFileNotFound
        /// NSManagedObjectModel creation fail
        case modelCreationError
    }
    
    /// Return NSPersistentStoreCoordinator object
    static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
        
        guard let modelURL = Bundle(for: Storage.self).url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            throw error
        }
        
        return coordinator
    }
}

final class Storage {
    
    static var shared = Storage()
    
    @available(iOS 10.0, *)
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: "EasyMapping", withExtension:"momd") else {
            fatalError("failed finding EasyMapping.momd")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("failed loading EasyMapping object model")
        }
        let container = NSPersistentContainer(name: "EasyMapping", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (storeDescription, error) in
            print("CoreData: Inited \(storeDescription)")
            guard error == nil else {
                print("CoreData: Unresolved error \(error as Any)")
                return
            }
        }
        return container
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(name: "EasyMapping")
        } catch {
            print("CoreData: Unresolved error \(error)")
        }
        return nil
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: Public methods
    
    enum SaveStatus {
        case saved, rolledBack, hasNoChanges
    }
    
    var context: NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            return persistentContainer.viewContext
        } else {
            return managedObjectContext
        }
    }
    
    func save() -> SaveStatus {
        if context.hasChanges {
            do {
                try context.save()
                return .saved
            } catch {
                context.rollback()
                return .rolledBack
            }
        }
        return .hasNoChanges
    }
    
    func resetStorage() {
        let coordinator : NSPersistentStoreCoordinator
        if #available(iOS 10.0, *) {
            coordinator = persistentContainer.persistentStoreCoordinator
        } else {
            coordinator = persistentStoreCoordinator!
        }
        if let store = coordinator.persistentStores.first {
            do {
                try coordinator.remove(store)
                try coordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                configurationName: nil,
                                                                at: nil,
                                                                options: store.options)
            }
            catch {
                print(error)
            }
            
        }
    }
    
}
