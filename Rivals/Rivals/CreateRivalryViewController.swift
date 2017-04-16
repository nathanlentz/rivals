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

    @IBOutlet weak var playerTableView: UITableView!
    
    var ref: FIRDatabaseReference!
    
    // Array of users for adding to table view
    var players:Array = [User]()

    
    @IBOutlet weak var gameNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

    }
    
    @IBAction func unwindAddPlayerView(segue: UIStoryboardSegue){
        if let sourceVC = segue.source as? FindUserTableViewController {
            if !players.contains(sourceVC.selectedUser) {
                self.players.append(sourceVC.selectedUser)
            }
        }
        
        self.playerTableView.reloadData()
        
    }
    
    @IBAction func startRivalryDidPress(_ sender: Any) {
        createRivalry()
        dismiss(animated: true, completion: nil)
    }
    // Create a rivalry given current users in list (plus current user) and string as board game name
    func createRivalry(){
        if gameNameText.text != "" && players.count > 1 {
            let currentUserId = FIRAuth.auth()?.currentUser?.uid
            
            var playerIds = [String]();
            for player in players {
                playerIds.append(player.uid!)
            }
            
            if POSTNewRivlary(creatorId: currentUserId!, gameName: gameNameText.text!, players: playerIds) {
                print("Yay")
            }
            else {
                print("Failed to submit")
            }
            
            // TODO init game history and comments field, etc
            
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
