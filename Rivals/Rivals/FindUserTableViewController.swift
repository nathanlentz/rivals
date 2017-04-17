//
//  FindUserTableViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/16/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class FindUserTableViewController: UITableViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet var addPlayerTableView: UITableView!
    var users = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var selectedUser = User()
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows class to know when text in search bar has changed
        searchController.searchResultsUpdater = self
        // Dim view when user types in search bar
        searchController.dimsBackgroundDuringPresentation = false
        // Ensures that searchbar shows only on this view
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        ref.child("profiles").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
        
            // Include code below to not include self in list
//            if let dict = snapshot.value as? [String: AnyObject] {
//                // Dont add user if it is current user
//                if dict["uid"] as? String != FIRAuth.auth()?.currentUser?.uid {
//                    self.users.append(snapshot.value as? NSDictionary)
//                    self.addPlayerTableView.insertRows(at: [IndexPath(row:self.users.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
//                }
//            }
            
            self.users.append(snapshot.value as? NSDictionary)
            self.addPlayerTableView.insertRows(at: [IndexPath(row:self.users.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        
        }
    }
    
    func filterUsers(searchText: String){
        self.filteredUsers = self.users.filter{ user in
            let username = user!["name"] as? String
            
            // If name is in search text, return that to filter array
            return(username?.lowercased().contains(searchText.lowercased()))!
        }
        
        tableView.reloadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        let user : NSDictionary?
        
        // Check if user is typing or nah
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        }
        else {
            user = self.users[indexPath.row]
        }
        
        cell.textLabel?.text = user?["name"] as? String
        cell.detailTextLabel?.text = user?["email"] as? String
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // need to unwind segue here
        let user: NSDictionary?
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]!
        }
        else {
            user = users[indexPath.row]!
        }
        
        self.selectedUser.uid = user?["uid"] as? String
        self.selectedUser.name = user?["name"] as? String
        self.selectedUser.wins = user?["wins"] as? Int
        self.selectedUser.losses = user?["losses"] as? Int
        self.selectedUser.profileImageUrl = user?["profileImageUrl"] as? String
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }


    @IBAction func cancelDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Update our search results
        filterUsers(searchText: self.searchController.searchBar.text!)
    }
    
    

}
