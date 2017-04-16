//
//  CreateRivalryViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/15/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class CreateRivalryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var ref: FIRDatabaseReference!
    
    // Array of users for adding to table view
    var players:Array = [User]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell as an AddPlayerViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayerViewCell") as! AddPlayerViewCell
        
        // TODO: Add Player image and add player wins/losses
        cell.userName.text! = players[indexPath.row].name!
        cell.winsLosses.text! = "Wins / Losses"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do stuff if selected?
    }
    
    
    // Swipe to remove players from array
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete data from array
            players.remove(at: indexPath.row)
            // Delete data from from
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    
    
    
    
    
}
