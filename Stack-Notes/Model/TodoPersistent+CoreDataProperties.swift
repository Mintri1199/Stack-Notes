//
//  TodoPersistent+CoreDataProperties.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/17/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//
//

import Foundation
import CoreData


extension TodoPersistent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoPersistent> {
        return NSFetchRequest<TodoPersistent>(entityName: "TodoPersistent")
    }

    @NSManaged public var done: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var color: NSObject?

}
