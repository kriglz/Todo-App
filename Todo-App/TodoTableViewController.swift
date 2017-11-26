//
//  TodoTableViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import RealmSwift


class UserDefaultsManager {
    // Create UserDefaults
    private let sortDefault = UserDefaults.standard
    private let sortKey = "sortBy"
    
    var sortByDefault: String {
        get {
            // Get the String from UserDefaults
            if let sortBy = sortDefault.string(forKey: sortKey) {
                return sortBy
            } else {
                return "priority"
            }
        }
        set {
            // Save String value to UserDefaults
            sortDefault.set(newValue, forKey: sortKey)
        }
    }
}




class TodoTableViewController: UITableViewController {

    
    @IBAction func search(_ sender: UIBarButtonItem) {
        searchBar.isHidden = false
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func updateTodoList(from segue: UIStoryboardSegue) {
        if let editor = segue.source as? TaskTableViewController {
            try? realm.write {
                realm.add(editor.taskModel!)
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func cancelEditTodoList(from segue: UIStoryboardSegue) {
        if segue.source is SearchViewController {
            tableView.reloadData()
        }
    }
    
    var todoList: Results<Task> {
        get {
            var newList = realm.objects(Task.self)
            newList = newList.sorted(byKeyPath: sortingKey, ascending: true)

            return newList
        }
    }
    
    
    var sortingKey: String = UserDefaultsManager().sortByDefault {
        didSet {
            UserDefaultsManager().sortByDefault = sortingKey
        }
    }

    @IBAction func sortingControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortingKey = "dueDate"
        case 1:
            sortingKey = "priority"
        case 2:
            sortingKey = "isCompleted"
        default:
            break
        }
        tableView.reloadData()
    }
    
    @IBOutlet weak var sortingControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        switch sortingKey {
        case "dueDate":
            sortingControl.selectedSegmentIndex = 0
        case "priority":
            sortingControl.selectedSegmentIndex = 1
        case "isCompleted":
            sortingControl.selectedSegmentIndex = 2
         default:
            sortingControl.selectedSegmentIndex = -1
        }
        
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TodoTableViewCell

        cell.taskModel = todoList[indexPath.row]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            try! realm.write {
                realm.delete(todoList[indexPath.row])
            }
            
            tableView.reloadData()
        }
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "task" {
            if let destinationViewController = (segue.destination.contents as? TaskTableViewController) {
                destinationViewController.navigationItem.title = "Edit task"
                
                if let indexOfselectedRow = tableView.indexPathForSelectedRow?.row {
                    var newTask = Task()
                    newTask = todoList[indexOfselectedRow]
                    destinationViewController.taskModel = newTask
                }
            }
        } else if segue.identifier == "addTask" {
            if let destinationViewController = (segue.destination.contents as? TaskTableViewController) {
                destinationViewController.navigationItem.title = "New task"
                let newTask = Task()
                newTask.title = ""
                destinationViewController.taskModel = newTask
            }
        } else if segue.identifier == "search" {
            if let destinationViewController = (segue.destination.contents as? SearchViewController) {
                destinationViewController.todoViewController = self
            }
        }
    }

}

extension UIViewController {
    
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
    
}
