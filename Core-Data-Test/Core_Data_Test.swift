//
//  Core_Data_Test.swift
//  Core-Data-Test
//
//  Created by Jackson Ho on 6/18/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import XCTest
import UIKit
import CoreData
import Foundation

@testable import Stack_Notes
// MARK: Change the Core Data Stack later to be able to create test easily
class Core_Data_Test: XCTestCase {
    // Custom managedObjectModel that will be used to initialize the persistent container.
    // The model object is created from test Bundle. For this to be possible, the model should also be added to the test target. I did this part in advance, so don't worry about it.
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    // Variable that holds an instane of the ToDoStorageManager
    var manager: TodoStore!
    // Mock Persistence container we'll use for the tests.
    // A default container will use a store of type NSSQLLiteStoreType
    // In this case we want to use the NSInMemoryStoreType, because we don't want to save our mock items to th real database.
    // In the in-memory database we can fake all the regular management of items without worrying about the real data.
    lazy var mockPersistantContainer: NSPersistentContainer = {
        // Initializing a container with a specified managedObjectModel
        let container = NSPersistentContainer(name: "ToDo", managedObjectModel: self.managedObjectModel)
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
        return container
    }()
    // MARK: Set up setUp once change Core Data
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func createMockItems() {
        func insertTodoItem(title: String) -> TodoPersistent? {
            let object = NSEntityDescription.insertNewObject(forEntityName: "TodoPersistent", into: mockPersistantContainer.viewContext)
            object.setValue(title, forKey: "title")
            object.setValue(nil, forKey: "taskDescription")
            object.setValue(false, forKey: "done")
            object.setValue(UIColor.red, forKey: "colorz")
            return object as? TodoPersistent
        }
        insertTodoItem(title: "Walk the Dog")
        insertTodoItem(title: "Do Laundry")
        insertTodoItem(title: "Cook Dinner")
        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print("Create fakes error \(error)")
        }
    }
    // Helper method to clear the data
    func clearData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoPersistent")
        let objects = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objects {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
    // Helper mehtod to count items in the store
    func itemsTotalCount() -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoPersistent")
        let results = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        return results.count
    }
}
