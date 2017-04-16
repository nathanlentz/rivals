//
//  UsersTableViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/15/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    let cellId = "cellId"
    
    var users = [User]()

    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = FIRDatabase.database().reference()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUsers()
        
        
    }
    
    // Retrieve all users (except current user)
    func fetchUsers(){
        
        ref.child("profiles").observe(.childAdded, with: { (snapshot) in
        // Add users into array and use that to populate rows
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.name = dict["name"] as? String
                user.email = dict["email"] as? String
                user.wins = dict["wins"] as? Int
                user.losses = dict["losses"] as? Int
                user.uid = dict["uid"] as? String
                
                if FIRAuth.auth()?.currentUser?.uid != user.uid {
                    self.users.append(user)
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        
        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Must dequeue cells for memory effecience
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
    
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "Wins: \(user.wins!) Losses: \(user.losses!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "userDetailSegue", sender: users[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueVC = segue.destination as! UserProfileViewController
        segueVC.user = sender as! User
    }
    
}


class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
