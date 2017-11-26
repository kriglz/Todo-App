//
//  SearchViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/25/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        let viewDissmisRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.view.addGestureRecognizer(viewDissmisRecognizer)
        
    }

    @objc func dismissController() {
        searchBar.resignFirstResponder()
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    
    
    var searchResults: Results<Task> {
        get {
            var results = realm.objects(Task.self)
            results = results.sorted(byKeyPath: "title", ascending: true)
            
            return results
        }
    }
    
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissController()
    }
   
}
