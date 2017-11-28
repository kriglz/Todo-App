//
//  TodoTableViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import RealmSwift




/// `UserDefaults` database to store `sortingKey` value.
class UserDefaultsManager {
    
    /// A standard `UserDefaults` database.
    private let sortingKeyDatabase = UserDefaults.standard
    
    /// A String, which defines the key for stored value.
    private let key = "sortingKey"
    
    /// A String which is stored as `key` value in `UserDefaults` database.
    var sortingKeyValue: String {
        get {
            // Returns the String for `key` from `UserDefaults` database.
            if let oldSortingKeyValue = sortingKeyDatabase.string(forKey: key) {
                return oldSortingKeyValue
            } else {
                return "priority"
            }
        }
        set {
            // Saves the new `key` value to `UserDefaults` database.
            sortingKeyDatabase.set(newValue, forKey: key)
        }
    }
}






/// TableViewController, wich shows complete list of todos.
class TodoTableViewController: UITableViewController {

    
    // MARK: - ViewDidLoad

    
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
    

    
    
    // MARK: - Variables

    
    /// An array of `Task` elements from `Realm` database sorted asendingly by `sortingKey`.
    private var todoList: Results<Task> {
        
        /// An array of fetched results using `Task` from Realm database.
        var list = realm.objects(Task.self)
        list = list.sorted(byKeyPath: sortingKey, ascending: true)
        
        return list
    }
    
    /// A String used to sort fetched results from `Realm`; stored in `UserDefaultsManager`.
    private var sortingKey: String = UserDefaultsManager().sortingKeyValue {
        didSet {
            UserDefaultsManager().sortingKeyValue = sortingKey
        }
    }

    /// UISegmentedControl which represents prefered sorting.
    @IBOutlet weak var sortingControl: UISegmentedControl!
    
    
    
    
    // MARK: - Actions
    
    
    /// Highlights selected segment.
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
        if editingStyle == UITableViewCellEditingStyle.delete {
            try! realm.write {
                realm.delete(todoList[indexPath.row])
            }
            tableView.reloadData()
        }
    }

    
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue to edit an existing task.
        if segue.identifier == "task" {
            if let destinationViewController = (segue.destination.contents as? TaskTableViewController) {
                
                destinationViewController.navigationItem.title = "Edit task"
                
                if let indexOfselectedRow = tableView.indexPathForSelectedRow?.row {
                    var newTask = Task()
                    newTask = todoList[indexOfselectedRow]
                    destinationViewController.taskModel = newTask
                }
            }
            
        // Segue to create a new task.
        } else if segue.identifier == "addTask" {
            if let destinationViewController = (segue.destination.contents as? TaskTableViewController) {
                destinationViewController.navigationItem.title = "New task"
                let newTask = Task()
                newTask.title = ""
                destinationViewController.taskModel = newTask
            }
            
        // Segue to searchBar window to filter todo list using search terms.
        } else if segue.identifier == "search" {
            if let destinationViewController = (segue.destination.contents as? SearchViewController) {
                destinationViewController.todoViewController = self
            }
        }
    }
    
    
    
    /// Saves edited changes to `Realm` database.
    @IBAction func updateTodoList(from segue: UIStoryboardSegue) {
        
        if let editor = segue.source as? TaskTableViewController {
            
            try? realm.write {
                if let newTitle = editor.newTitle {
                    editor.taskModel?.title = newTitle
                }
                if let newDueDate = editor.newDueDate {
                    editor.taskModel?.dueDate = newDueDate
                }
                if let newPriority = editor.newPriority {
                    editor.taskModel?.priority = newPriority
                }
                
                realm.add(editor.taskModel!)
                
                // Setting TaskTableViewController Realm data model instance to nil to avoid memory leak.
                editor.resetDataModel()
            }
            tableView.reloadData()
        }
    }
    
    
    
    ///  Discards unsaved TaskTableViewController instance changes.
    @IBAction func cancelEditTodoList(from segue: UIStoryboardSegue) {
        
        if let editor = segue.source as? TaskTableViewController {
            
            editor.resetDataModel()
        }
    }
}



extension UIViewController {
    /// The destination view controller which is embedded in the `UINavigationController`.
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
