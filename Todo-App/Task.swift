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
    
    /// Primary key for the object in realm.
    @objc let id: String = UUID().uuidString
    
    /// A boolean which indicates if the task has been completed.
    @objc dynamic var isCompleted: Bool = false
    
    /// A string which should describe what the task is all about.
    @objc dynamic var title: String = "Default todo task"
    
    /// The due date for the task.
    @objc dynamic var dueDate: Date = Date()
    
    /// The level of priority of the task.
    @objc dynamic var priority: TaskPriority = .none
    
}

/// Defines possible priority states as Int -
/// that is required for Realm implementation.
@objc enum TaskPriority: Int {
    case high
    case medium
    case low
    case none
}
