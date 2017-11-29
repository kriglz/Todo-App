//
//  TodoTableViewCell.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit




/// Manages cell View of todo task.
class TodoTableViewCell: UITableViewCell {
    
    
    // MARK: - Variables and Outlets
    
    
    var taskModel: Task! { didSet { updateUI() }}
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoTaskLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    
    
    
    // MARK: - Methods and Actions

    
    /// Changes the `completedButton` state.
    @IBAction func checkboxButton(_ sender: UIButton) {
        realm.beginWrite()
        taskModel.isCompleted = !taskModel.isCompleted
        try? realm.commitWrite()

        updateUI()
    }
    
    
    /// Updates the appearance of UI.
    private func updateUI() {
        
        // Sets task title.
        todoTaskLabel.text = taskModel.title
        
        // Sets date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"        
        dateLabel.text = dateFormatter.string(from: taskModel.dueDate)
        
        // Sets `completedButton`.
        if taskModel.isCompleted {
            completedButton.isSelected = true
        } else {
            completedButton.isSelected = false
        }
        
        // Sets priority.
        switch taskModel.priority {
        case .high:
            priorityLabel.text = "!!!"
        case .medium:
            priorityLabel.text = "!!"
        case .low:
            priorityLabel.text = "!"
        default:
            priorityLabel.text = ""
        }
    }
}
