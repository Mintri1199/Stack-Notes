//
//  TaskModel.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/17/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import Foundation
import UIKit

struct Todo {
    let title: String
    let color: UIColor
    var description: String?
    var done: Bool
    init(title: String, description: String?=nil, done: Bool=false, color: UIColor) {
        self.title = title
        self.description = description
        self.done = done
        self.color = color
    }
}
