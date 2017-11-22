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
    var taskModel: Task! {
        didSet {
            refreshAppearance()
        }
    }

    @IBAction func checkboxButton(_ sender: UIButton) {
        taskModel.isCompleted = !taskModel.isCompleted

        refreshAppearance()
    }
    
    private func refreshAppearance() {
        todoTaskLabel.text = taskModel.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        dateLabel.text = dateFormatter.string(from: taskModel.created)
        
        if taskModel.isCompleted {
            completedButton.isSelected = true
        } else {
            completedButton.isSelected = false
        }
    }
    
}
