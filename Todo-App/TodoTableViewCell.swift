//
//  TodoTableViewCell.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoTaskLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    var taskModel: Task! {
        didSet {
            updateUI()
        }
    }

    @IBAction func checkboxButton(_ sender: UIButton) {
        realm.beginWrite()
        taskModel.isCompleted = !taskModel.isCompleted
        try? realm.commitWrite()

        updateUI()
    }
    
    private func updateUI() {
        todoTaskLabel.text = taskModel.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"        
        dateLabel.text = dateFormatter.string(from: taskModel.dueDate)
        
        if taskModel.isCompleted {
            completedButton.isSelected = true
        } else {
            completedButton.isSelected = false
        }
        
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
