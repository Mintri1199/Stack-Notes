//
//  TaskViewModel.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/17/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct TodoViewModel {
    let title: String
    let color: UIColor
    var description: String?
    var done: Bool
    let entityId: NSManagedObjectID
    
    init(todo: TodoPersistent) {
        self.title = todo.title!
        self.color = todo.color as! UIColor
        self.description = todo.description
        self.done = todo.done
        self.entityId = todo.objectID
    }
}
