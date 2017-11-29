//
//  TaskTableViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit




/// Manages single todo task View.
class TaskTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate {

    
    // MARK: - ViewDidLoad
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        todoTaskLabel.delegate = self

        if taskModel != nil {
            updateUI()
        }

        // Setting `placeholderLabel` properties and hidding it if `todoTaskLabel` is not empty.
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter new task..."
        placeholderLabel.font = todoTaskLabel.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.sizeToFit()
        todoTaskLabel.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 7)
        placeholderLabel.isHidden = !todoTaskLabel.text.isEmpty
        
        taskPriorityControler.addTarget(self, action: #selector(priorityChange), for: .valueChanged)
    }
    
    

    
    // MARK: - Instances

    
    /// A `Task` instance containing `title`, `priotity`, `dueDate`.
    var taskModel: Task?
    /// An UILabel which acts as placeholder to inform about text field.
    private var placeholderLabel : UILabel!
    /// An UITextView which represents task title.
    @IBOutlet weak var todoTaskLabel: UITextView!
    /// An UIDatePicker which represents due date of the task.
    @IBOutlet weak var dateLabel: UIDatePicker!
    /// An UISegmentedControl which represents priotity of the task.
    @IBOutlet weak var taskPriorityControler: UISegmentedControl!
    
    
    
    
    // MARK: - Methods

    
    /// Updates appearance of UI.
    private func updateUI(){
        
        // Sets dueDate.
        dateLabel?.date = taskModel!.dueDate

        // Sets task title.
        todoTaskLabel?.text = taskModel!.title

        // Sets priority.
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
    
    
    /// Resets data model and related instances to nil.
    func resetDataModel(){
        newPriority = nil
        newTitle = nil
        newDueDate = nil
        taskModel = nil
    }
    

    
    
    // MARK: - Actions

    
    /// Sets a new date if user changes it.
    var newDueDate: Date?
    @IBAction func setDueDate(_ sender: UIDatePicker) {
        newDueDate = sender.date
    }
    
    /// Sets a new  priority if user changes it.
    var newPriority: TaskPriority?
    @objc func priorityChange(){
        switch taskPriorityControler.selectedSegmentIndex {
        case 1:
            newPriority = .low
        case 2:
            newPriority = .medium
        case 3:
            newPriority = .high
        default:
            newPriority = .none
        }
    }
    

    
    
    
    
    // MARK: - TextView delegate
    
    
    /// A String which is set if user is editing task title.
    var newTitle: String?
    func textViewDidChange(_ textView: UITextView) {
        newTitle = todoTaskLabel.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }

        if textView.text.isEmpty && text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
        
        return true
    }
}
