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
    var container: NSPersistentContainer!
    init(test: Bool) {
        super.init()
        // Instanciate the right persistent container depending whether
        if test {
            // Assign container to the mock
            let managedObjectModel: NSManagedObjectModel = {
                let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
                return managedObjectModel
            }()
            container = NSPersistentContainer(name: "ToDo", managedObjectModel: managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType // where we set the type
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                // Check if the data store is in memory
                precondition( description.type == NSInMemoryStoreType )
                // Check for errors
                if let error = error {
                    fatalError("Something went wrong, \(error)")
                }
            }
        } else {
            // Assign it to container for the app
            container = NSPersistentContainer(name: "Todo_Task")
            // load the saved database if it exists, creates it if it does not,
            // and returns an error under failure conditions
            container.loadPersistentStores(completionHandler: { (description, error) in
                if let error = error {
                    print("Error setting up Core Data (\(error)).")
                }
            })
        }
    }
    // MARK: Save context
    func saveContext() {
        let viewContext = container.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: Create new todo
    func createTodo(todo: Todo) -> TodoPersistent? {
        let newTodo = NSEntityDescription.insertNewObject(forEntityName: "TodoPersistent", into: container.viewContext) as? TodoPersistent
        newTodo?.color = todo.color
        newTodo?.title = todo.title
        newTodo?.taskDescription = todo.description
        newTodo?.done = todo.done
        saveContext()
        return newTodo
    }
    // MARK: Fetch persisted data
    func fetchPersistedData(completion: (Result<[TodoPersistent], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TodoPersistent> = TodoPersistent.fetchRequest()
        let viewContext = container.viewContext
        do {
            let allTodos = try viewContext.fetch(fetchRequest)
            completion(.success(allTodos))
        } catch {
            completion(.failure(error))
        }
    }
    // MARK: DeletePersistedTodo
    func deletePersistedTodo(entityId: NSManagedObjectID) {
        let object: TodoPersistent = container.viewContext.object(with: entityId) as! TodoPersistent
        container.viewContext.delete(object)
        saveContext()
    }
    // MARK: FetchOneTodo
    func fetchOneTodo(entityId: NSManagedObjectID) -> TodoPersistent? {
        let object: TodoPersistent = container.viewContext.object(with: entityId) as! TodoPersistent
        return object
    }
    // MARK: UpdateTodo
    func updateTodo(entityId: NSManagedObjectID, todo: Todo) {
        let udpateQueue = DispatchQueue.global(qos: .userInteractive)
        udpateQueue.async {
            guard let persistent = self.fetchOneTodo(entityId: entityId) else { return }
            persistent.setValue(todo.color, forKey: "color")
            persistent.setValue(todo.title, forKey: "title")
            persistent.setValue(todo.description, forKey: "taskDescription")
            persistent.setValue(todo.done, forKey: "done")
        }
    }
}
