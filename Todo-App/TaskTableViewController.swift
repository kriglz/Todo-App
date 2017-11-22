//
//  TaskTableViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        todoTaskLabel.delegate = self

        if taskModel != nil {
            updateUI()
        }
        


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
    
    @objc func priorityChange() {
        switch taskPriorityControler.selectedSegmentIndex {
        case 1:
            taskModel?.priority = .low
        case 2:
            taskModel?.priority = .medium
        case 3:
            taskModel?.priority = .high
        default:
            taskModel?.priority = .none
        }
    }
    
    var placeholderLabel : UILabel!
    @IBOutlet weak var todoTaskLabel: UITextView!
    @IBOutlet weak var dateLabel: UIDatePicker!
    @IBOutlet weak var taskPriorityControler: UISegmentedControl!
    
    @IBAction func setDueDate(_ sender: UIDatePicker) {
        taskModel?.dueDate = sender.date
    }
    
    


    
    var taskModel: Task?


    
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
    
    
    func textViewDidChange(_ textView: UITextView) {
        taskModel?.title = todoTaskLabel.text
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            if textView.text.isEmpty {
                placeholderLabel.isHidden = false
            } else {
                placeholderLabel.isHidden = true
            }
            return true
        }
    }
}
