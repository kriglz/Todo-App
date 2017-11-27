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
    
    weak var todoViewController: TodoTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        
        let viewDissmisRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        viewDissmisRecognizer.delegate = self
        self.view.addGestureRecognizer(viewDissmisRecognizer)
        
        searchResultTableView.estimatedRowHeight = searchResultTableView.rowHeight
        searchResultTableView.rowHeight = UITableViewAutomaticDimension
        searchResultTableView.isHidden = true
    }

    @objc func dismissController() {
        searchResultTableView.isHidden = true
        searchBar.resignFirstResponder()
        todoViewController?.tableView.reloadData()
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    private var searchKeyword: String?
    
    var searchResults: Results<Task> {
        get {
            var results = realm.objects(Task.self)

            if let searchKeyword = searchKeyword {
                let predicate = NSPredicate(format: "title CONTAINS[c] %@ ", searchKeyword)
                
                results = results.filter(predicate).sorted(byKeyPath: "dueDate", ascending: true)
            }
            return results

        }
    }

    
    
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.isEmpty)! {
            searchResultTableView.isHidden = true
        } else {
            searchKeyword = searchBar.text
            searchResultTableView.isHidden = false
            searchResultTableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TodoTableViewCell
        cell.taskModel = searchResults[indexPath.row]
        return cell
    }
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissController()
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



extension UITableView {
    //forces a cell to be created for every row
    
    func minimunSize(forSize section: Int) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for row in 0..<numberOfRows(inSection: section){
            let indexPath = IndexPath(row: row, section: section)
            if let cell = cellForRow(at: indexPath) ?? dataSource?.tableView(self, cellForRowAt: indexPath) {
                let cellSize = cell.contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
                let tableWidth = self.bounds.width
                width = max(width, tableWidth)
                height += heightForRow(at: indexPath)
            }
        }
        return CGSize(width: width, height: height)
    }
    
    func heightForRow(at indexPath: IndexPath? = nil) -> CGFloat {
        if indexPath != nil, let heigh = delegate?.tableView?(self, heightForRowAt: indexPath!) {
            return heigh
        } else {
            return rowHeight
        }
    }
}
