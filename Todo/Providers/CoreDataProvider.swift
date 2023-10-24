//
//  CoreDataProvider.swift
//  Todo
//
//  Created by Mohammad Azam on 10/23/23.
//

import Foundation
import CoreData


class CoreDataProvider {
    
    static let shared = CoreDataProvider()
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static var preview: CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)
        let viewContext = provider.viewContext
        
        for index in 1..<10 {
            let todoItem = TodoItem(context: viewContext)
            todoItem.title = "TodoItem \(index)"
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        } 
        
        return provider
    }()
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "TodoModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Core Data store failed to initialize \(error)")
            }
        }
    }
    
}
