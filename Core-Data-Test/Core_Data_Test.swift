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
    var manager: TodoStore!
    // MARK: Set up setUp once change Core Data
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        manager = TodoStore(test: true)
        createMockItems()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        clearData()
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
    func test_create_todo() {
        //Given the name & completion status
        let name = "Go the gym"
        //When adding an item
        let todo = manager.createTodo(todo: Todo(title: name, description: nil, done: false, color: .blue))
        //Assert the returned item is not nil
        XCTAssertNotNil(todo)
        XCTAssertEqual(4, itemsTotalCount())
    }
    func test_fetch_all_todo() {
        XCTAssertEqual(itemsTotalCount(), 3)
    }
    func test_remove_todo() {
        let oldTotalCount = itemsTotalCount()
        var allItems: [TodoPersistent] = []
        // Fetch all the items in the persistent container
        manager.fetchPersistedData {(result) in
            switch result {
            case .success(let todos):
                allItems = todos
            case .failure(let error):
                print("Unable to fetch all items from test")
                print(error)
            }
        }
        // Delete the first item by its objectId
        manager.deletePersistedTodo(entityId: allItems[0].objectID)
        // Save it
        manager.saveContext()
        // The item count should not equal to the old count
        XCTAssertNotEqual(itemsTotalCount(), oldTotalCount)
        XCTAssertEqual(itemsTotalCount(), 2)
    }
    func test_update_one_todo() {
        var allItems: [TodoPersistent] = []
        // Fetch all the items in the persistent container
        manager.fetchPersistedData {(result) in
            switch result {
            case .success(let todos):
                allItems = todos
            case .failure(let error):
                print("Unable to fetch all items from test")
                print(error)
            }
        }
        // Use the first persistent as control
        guard let oldPersistent = allItems.first else { print("There were no persistent"); return }
        // Define new attributes
        let newAttributes = Todo.init(title: "UpdatedTitle", description: "Hello", done: false, color: UIColor.lightGray)
        // Update it
        manager.updateTodo(entityId: oldPersistent.objectID, todo: newAttributes)
        // Fetch the same todo again
        let updatedTodo = manager.fetchOneTodo(entityId: oldPersistent.objectID)
        XCTAssertNotNil(updatedTodo)
        XCTAssert(updatedTodo?.color == UIColor.lightGray)
        XCTAssert(updatedTodo?.done == false)
        XCTAssert(updatedTodo?.title == "UpdatedTitle")
        XCTAssert(updatedTodo?.description == "Hello")
    }
    func createMockItems() {
        func insertTodoItem(title: String) -> TodoPersistent? {
            let object = NSEntityDescription.insertNewObject(forEntityName: "TodoPersistent", into: manager.container.viewContext)
            object.setValue(title, forKey: "title")
            object.setValue(nil, forKey: "taskDescription")
            object.setValue(false, forKey: "done")
            object.setValue(UIColor.red, forKey: "color")
            return object as? TodoPersistent
        }
        insertTodoItem(title: "Walk the Dog")
        insertTodoItem(title: "Do Laundry")
        insertTodoItem(title: "Cook Dinner")
        do {
            try manager.container.viewContext.save()
        } catch {
            print("Create fakes error \(error)")
        }
    }
    // Helper method to clear the data
    func clearData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoPersistent")
        let objects = try! manager.container.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objects {
            manager.container.viewContext.delete(obj)
        }
        try! manager.container.viewContext.save()
    }
    // Helper mehtod to count items in the store
    func itemsTotalCount() -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoPersistent")
        let results = try! manager.container.viewContext.fetch(fetchRequest)
        return results.count
    }
}
