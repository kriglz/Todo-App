//
//  TaskTableViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taskModel != nil {
            updateUI()
        }

    }
    
    @IBOutlet weak var todoTaskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskPriorityControler: UISegmentedControl!
    
    var taskModel: Task?{
        didSet {
            updateUI()
        }
    }

    
    private func updateUI(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        dateLabel?.text = dateFormatter.string(from: taskModel!.dueDate)
        
        
        todoTaskLabel?.text = taskModel!.title
        

        switch taskModel!.priority {
        case .high:
            taskPriorityControler?.selectedSegmentIndex = 3
        case .medium:
            taskPriorityControler?.selectedSegmentIndex = 2
        case .low:
            taskPriorityControler?.selectedSegmentIndex = 1
        default:
            taskPriorityControler?.selectedSegmentIndex = 0
        }
    }
}
