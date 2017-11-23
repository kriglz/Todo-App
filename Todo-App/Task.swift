//
//  Task.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import RealmSwift

/// A model object which represents one item in a to do list.
class Task: Object {
    
    /// A boolean which indicates if the task has been completed.
    @objc dynamic var isCompleted: Bool = false
    
    /// A string which should describe what the task is all about.
    @objc dynamic var title: String = "Default todo task"
    
    /// The due date for the task.
    @objc dynamic var dueDate: Date = Date()
    
    /// The level of priority of the task.
    @objc dynamic var priority: TaskPriority = .none
    
    /// Creates a task with a specified title. Uses default values for all other properties.
//    init(title: String) {
//        self.isCompleted = false
//        self.title = title
//        self.dueDate = Date()
//        self.priority = .none
//
//        super.init()
//    }

  
    
//    required init() {
//        self.isCompleted = false
//        self.title = ""
//        self.dueDate = Date()
//        self.priority = .none
//
//        super.init()
//    }

//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        fatalError("init(realm:schema:) has not been implemented")
//    }
//
//    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
//    }

    
}

@objc enum TaskPriority: Int {
    case high
    case medium
    case low
    case none
}
