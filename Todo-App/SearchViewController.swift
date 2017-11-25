//
//  SearchViewController.swift
//  Todo-App
//
//  Created by Kristina Gelzinyte on 11/25/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

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
   
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissController()
    }
   
}
