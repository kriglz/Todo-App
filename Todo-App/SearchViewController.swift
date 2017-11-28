//
//  SearchViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/25/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    
    // MARK: - ViewDidLoad

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        // Init of `UITapGestureRecognizer`.
        let viewDissmisRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        viewDissmisRecognizer.delegate = self
        self.view.addGestureRecognizer(viewDissmisRecognizer)
        
        // Defining tableView row height and set tableView to be hidden on appearance.
        searchResultTableView.estimatedRowHeight = searchResultTableView.rowHeight
        searchResultTableView.rowHeight = UITableViewAutomaticDimension
        searchResultTableView.isHidden = true
    }

    

    
    // MARK: - Indtsnces and Outlets

    /// An UISearchBar which text is used to filter todo list.
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// An UITableView which shows todo list search results.
    @IBOutlet weak var searchResultTableView: UITableView!
    
    /// A reference to parent `TodoTableViewController` controller.
    weak var todoViewController: TodoTableViewController? = nil
    
    /// A String whcih represents UISearchBar text.
    private var searchKeyword: String?
    
    /// An Array of `Task` which is filtered by `searchKeyword`.
    private var searchResults: Results<Task> {
        
        /// An array of fetched results using `Task` from Realm database.
        var results = realm.objects(Task.self)
        
        if let searchKeyword = searchKeyword {
            /// A NSPredicate to filter `results`.
            let predicate = NSPredicate(format: "title CONTAINS[c] %@ ", searchKeyword)
            
            // Returns sorted and filtered search results.
            results = results.filter(predicate).sorted(byKeyPath: "dueDate", ascending: true)
        }
        return results
    }
    
    
    
    
    // MARK: - Tap gesture action
    
    
    /// Dismissed current controller and reloads table view in parent controller.
    @objc func dismissController() {
        searchResultTableView.isHidden = true
        searchBar.resignFirstResponder()
        todoViewController?.tableView.reloadData()
        self.dismiss(animated: true)
    }
    
    
    
    
    // MARK: - SearchBarButton delegate methods

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Hides searchResultTableView if no text is entered to searchBar.
        if (searchBar.text?.isEmpty)! {
            searchResultTableView.isHidden = true
       
        } else {
            // Searches tasks by using enetered text to searchBar.
            searchKeyword = searchBar.text
            searchResultTableView.isHidden = false
            searchResultTableView.reloadData()
            
            //Sets tableView height based on row heigths.
            var tableHeight: CGFloat = 0
            for index in 0..<searchResults.count {
                tableHeight += searchResultTableView.rectForRow(at: IndexPath(row: index, section: 0)).height
            }
            searchResultTableView.frame.size.height = tableHeight
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissController()
    }
    
    
    
    
    
    // MARK: - Table view data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TodoTableViewCell
        cell.taskModel = searchResults[indexPath.row]
        return cell
    }
    
    
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue to edit an existing task.
        if segue.identifier == "task" {
            if let destinationViewController = (segue.destination.contents as? TaskTableViewController) {
                destinationViewController.navigationItem.title = "Edit task"
                
                if let indexOfselectedRow = searchResultTableView.indexPathForSelectedRow?.row {
                    var newTask = Task()
                    newTask = searchResults[indexOfselectedRow]
                    destinationViewController.taskModel = newTask
                }
            }
        }
    }
}




extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view =  touch.view, view.isDescendant(of: searchResultTableView) {
            return false
        }
        return true
    }
}

