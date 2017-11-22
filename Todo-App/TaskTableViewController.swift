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
    
    
    @IBOutlet weak var dateLabel: UIDatePicker!
    @IBOutlet weak var todoTaskLabel: UITextField!
    @IBOutlet weak var taskPriorityControler: UISegmentedControl!
    
    var taskModel: Task? {
        didSet {
            updateUI()
        }
    }

    private func updateUI(){
        dateLabel?.date = taskModel!.dueDate

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
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 || indexPath.section == 1 {
                return true
        }
        return false
    }

    
}
