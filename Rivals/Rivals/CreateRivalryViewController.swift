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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = RIVALS_SECONDARY

    }
    
    /**
     We use an unwind segue to get the selected user from player search
     */
    @IBAction func unwindAddPlayerView(segue: UIStoryboardSegue){
        if let sourceVC = segue.source as? FindUserTableViewController {
            if !players.contains(sourceVC.selectedUser) {
                self.players.append(sourceVC.selectedUser)
            }
        }
        
        self.playerTableView.reloadData()
        
    }
    
    /** 
     On 'Start' press, try to create a rivalry and return to home if success
     */
    @IBAction func startRivalryDidPress(_ sender: Any) {
        if createRivalry(){
            // TODO alert
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController")
            self.present(vc, animated: true, completion: nil)
        }
        else {
            print("Error creating rivalry")
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     Create a rivalry given current users in list (plus current user) and string as board game name
     */
    func createRivalry() -> Bool{
        // TODO Notify user if validation is not right
        var success = false
        
        if gameNameText.text != "" && players.count > 1 {
            let currentUserId = FIRAuth.auth()?.currentUser?.uid
            
            var playerIds = [String]();
            for player in players {
                playerIds.append(player.uid!)
            }
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            
            if createNewRivlary(creatorId: currentUserId!, gameName: gameNameText.text!, players: playerIds, creationDate: timestamp) {
                success = true
            }
            else {
                success = false
            }
            
            // TODO init game history and comments field, etc
            
        }
        
        else {
            print("Failed to submit")
            let alertController = UIAlertController(title: "Error", message: "Ensure you have more than 1 person and a game name for your rivalry", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            success = false
        }
        return success
        
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
        let user = players[indexPath.row]
        cell.userName.text! = players[indexPath.row].name!
        cell.winsLosses.text! = "Wins / Losses"
        cell.profileImage.image = UIImage(named: "profile")
        cell.profileImage.contentMode = .scaleAspectFill
        
        if let userProfileImageUrl = user.profileImageUrl {
            cell.profileImage.loadImageUsingCacheWithUrlString(urlString: userProfileImageUrl)
        }
        
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
