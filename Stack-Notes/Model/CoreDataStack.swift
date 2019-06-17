//
//  CoreDataStack.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import Foundation
import CoreData

class TodoStore: NSObject {
    // MARK: PersistentContainer
    let persistentContainer: NSPersistentContainer = {
        // creates the NSPersistentContainer object
        let container = NSPersistentContainer(name: "Todo_Task")
        // load the saved database if it exists, creates it if it does not,
        // and returns an error under failure conditions
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        })
        return container
    }()
    // MARK: Save context
    func saveContext() {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: Fetch persisted data
    func fetchPersistedData(completion: (Result<[TodoPersistent], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TodoPersistent> = TodoPersistent.fetchRequest()
        let viewContext = persistentContainer.viewContext
        do {
            let allTodos = try viewContext.fetch(fetchRequest)
            completion(.success(allTodos))
        } catch {
            completion(.failure(error))
        }
    }
    // MARK: DeletePersistedTodo
    func deletePersistedTodo(entityId: NSManagedObjectID) {
        let object: TodoPersistent = persistentContainer.viewContext.object(with: entityId) as! TodoPersistent
        persistentContainer.viewContext.delete(object)
    }
    // MARK: FetchOneTodo
    func fetchOneTodo(entityId: NSManagedObjectID) -> TodoPersistent{
        let object: TodoPersistent = persistentContainer.viewContext.object(with: entityId) as! TodoPersistent
        return object
    }
}
