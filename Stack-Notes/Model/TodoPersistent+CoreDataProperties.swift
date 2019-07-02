//
//  TodoPersistent+CoreDataProperties.swift
//  
//
//  Created by Jackson Ho on 7/1/19.
//
//

import Foundation
import CoreData


extension TodoPersistent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoPersistent> {
        return NSFetchRequest<TodoPersistent>(entityName: "TodoPersistent")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var done: Bool
    @NSManaged public var small: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?

}
