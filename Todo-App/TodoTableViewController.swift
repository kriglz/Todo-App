//
//  TodoTableViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import RealmSwift

class TodoTableViewController: UITableViewController {

    @IBAction func updateTodoList(from segue: UIStoryboardSegue) {
        if let editor = segue.source as? TaskTableViewController {
            
            tableView.reloadData()

//
//            if let newTask = editor.taskModel {
//            }
        }
    }
    

    var todoTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let exampleTask = Task()
        todoTasks.append(exampleTask)
 
        
        
//        let realm = try! Realm()
//
//        try! realm.write {
//            realm.add(todoTasks, update: true)
//        }
//
//        let result = try? realm.objects(Task.self)
//        print(result)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    
    
    

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TodoTableViewCell

        cell.taskModel = todoTasks[indexPath.row]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            todoTasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "task" {
            if let destinationViewController = (segue.destination.contents as? TaskTableViewController) {
                destinationViewController.navigationItem.title = "Edit task"
                
                if let indexOfselectedRow = tableView.indexPathForSelectedRow?.row {
                    destinationViewController.taskModel = todoTasks[indexOfselectedRow]
                }
            }
        }
        if segue.identifier == "addTask" {
            if let destinationViewController = (segue.destination.contents as? TaskTableViewController) {
                destinationViewController.navigationItem.title = "New task"
                let newTask = Task()
                newTask.title = ""
                todoTasks.append(newTask)
                destinationViewController.taskModel = newTask
            }
        }
    }

}

extension UIViewController
{
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
