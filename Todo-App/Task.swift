//
//  Task.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

/// A model object which represents one item in a to do list.
class Task {
    
    /// A boolean which indicates if the task has been completed.
    var isCompleted: Bool
    
    /// A string which should describe what the task is all about.
    var title: String
    
    /// The due date for the task.
    let dueDate: Date
    
    /// The level of priority of the task.
    var priority: TaskPriority
    
    /// Creates a task with a specified title. Uses default values for all other properties.
    init(title: String) {
        self.isCompleted = false
        self.title = title
        self.dueDate = Date()
        self.priority = .none
    }

}

enum TaskPriority {
    case high
    case medium
    case low
    case none
}
