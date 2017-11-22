//
//  TodoTableViewCell.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    var taskModel: Task? = nil {
        didSet {
            self.todoTaskLabel.text = taskModel?.title 
        }
    }

    @IBAction func checkboxButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoTaskLabel: UILabel!
    
    
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
