//
//  Task.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

/// A model object which represents one item in a to do list.
struct Task {
    
    /// A boolean which indicates if the task has been completed.
    var isCompleted: Bool
    
    /// A string which should describe what the task is all about.
    var title: String
    
    /// The time at which the date was first created.
    let created: Date
    
    /// The level of priority of the task.
    var priority: TaskPriority
    
    /// Creates a task with a specified title. Uses default values for all other properties.
    init(title: String) {
        self.isCompleted = false
        self.title = title
        self.created = Date()
        self.priority = .medium
    }

}

enum TaskPriority {
    case high
    case medium
    case low
}
