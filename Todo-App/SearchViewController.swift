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
        self.view.addGestureRecognizer(viewDissmisRecognizer)
        
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
