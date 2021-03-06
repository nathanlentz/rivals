//
//  UserProfileViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/16/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    var user = User()
    var currentUser = User()
    var currentUserFriendsList = [String]()
    var doesRequestExist = false
    var currentUserId: String?

    
    @IBOutlet weak var bioTextField: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var friendButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = user.name!
        self.friendButton.backgroundColor = RIVALS_PRIMARY
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        self.currentUserId = FIRAuth.auth()?.currentUser?.uid
    
        
        loadUserSettings()
        getCurrentUser()
        getFriendStatus()
        
        self.winsLabel.text = String(user.wins!)
        self.lossesLabel.text = String(user.losses!)

    }


    func loadUserSettings() {
        self.winsLabel.text = String(self.user.wins!)
        self.lossesLabel.text = String(self.user.losses!)
        if self.user.profileImageUrl != nil {
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: self.user.profileImageUrl!)
        }
        if self.user.bio == "" || self.user.bio == nil {
            self.bioTextField.text = "Looks like \(self.user.name ?? "this user") doesn't have a bio yet. What a loser"
        }
            
        else {
            self.bioTextField.text = self.user.bio
        }
    }
    
    func getCurrentUser() {
        ref.child("profiles").child(currentUserId!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                self.currentUser.uid = dict["uid"] as? String
                self.currentUser.name = dict["name"] as? String
                self.currentUser.bio = dict["bio"] as? String

            }
        }, withCancel: nil)
        
    }
    
    func getFriendStatus() {
        ref.child("profiles").child(currentUserId!).child("friends").child(self.user.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let friendsDict = snapshot.value as? [String : Any] {
                let friend = Friend()
                friend.friendUid = friendsDict["friend_uid"] as? String
                friend.name = friendsDict["name"] as? String
                friend.status = friendsDict["status"] as? String
                if friend.friendUid == self.user.uid {
                    if friend.status == "pending" {
                        self.friendButton.setTitle("Pending", for: .normal)
                        self.friendButton.backgroundColor = RIVALS_BLUISH
                    }
                    else if friend.status == "Accepted" {
                        self.friendButton.setTitle("Remove Friend", for: .normal)
                        // Turn this into a red button
                    }
                    else {
                        self.friendButton.setTitle("Add Friend", for: .normal)
                    }
                }
            }
        })
    }
    
    @IBAction func addFriendButtonDidPress(_ sender: UIButton) {
        
        if self.friendButton.titleLabel?.text == "Add Friend" {
            // Add pending friend request to current user
            let friendData = ["status": "pending", "name": self.user.name!, "friend_uid": self.user.uid!]
            ref.child("profiles").child(self.currentUser.uid!).child("friends").child(self.user.uid!).setValue(friendData)
            
            // Add a request to the friend receiving the request
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            let userRequest = ["requester_uid": self.currentUser.uid!, "request_date": timestamp, "requester_name": self.currentUser.name!]
            ref.child("profiles").child(self.user.uid!).child("requests").child(self.currentUser.uid!).setValue(userRequest)
            
            self.friendButton.setTitle("Pending", for: UIControlState.normal)
            self.friendButton.backgroundColor = RIVALS_BLUISH
        }
        
        // If request is pending, just pop an alert saying the request is pending
        if self.friendButton.titleLabel?.text == "Pending" {
            let alertController = UIAlertController(title: "Hey!", message: "Your friend request is pending. Go tell your buddy to accept!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if self.friendButton.titleLabel?.text == "Remove Friend" {
            
            // Alert asking for confirmation
            let alertController = UIAlertController(title: "Whoa!", message: "Too much beef between you two?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let removeAction = UIAlertAction(title: "Remove Friend", style: .default) { (_) -> Void in
                // Remove from current user 
                ref.child("profiles").child(self.currentUser.uid!).child("friends").child(self.user.uid!).removeValue()
                
                // Remove from user
                ref.child("profiles").child(self.user.uid!).child("friends").child(self.currentUser.uid!).removeValue()
                
                self.friendButton.setTitle("Add Friend", for: .normal)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(removeAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            // Remove if yes
        }

    }


}
