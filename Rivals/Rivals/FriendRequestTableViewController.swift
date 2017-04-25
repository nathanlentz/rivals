//
//  FriendRequestTableViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/22/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestTableViewController: UITableViewController {
    
    var currentUserId: String?
    var requests = [FriendRequest]()
    var sentRequests = [Friend]()
    var tableHeader = ["Pending Requests", "Sent Requests"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Friend Requests"
    }

    override func viewWillAppear(_ animated: Bool) {
        self.currentUserId = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("profiles").child(self.currentUserId!).child("requests").observe(.childAdded, with: { (snapshot) in
            if let requestDict = snapshot.value as? [String : Any] {
                let request = FriendRequest()
                request.requesterName = requestDict["requester_name"] as? String
                request.date = requestDict["request_date"] as? String
                request.requesterUid = requestDict["requester_uid"] as? String
                self.requests.append(request)
                
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
            }
        })
        
        // Check for pending requests sent by current user
        ref.child("profiles").child(self.currentUserId!).child("friends").observe(.childAdded, with: { (snapshot) in
            if let pendingRequest = snapshot.value as? [String : Any] {
                let friend = Friend()
                if pendingRequest["status"] as? String == "pending" {
                    friend.name = pendingRequest["name"] as? String
                    friend.status = "Pending"
                    self.sentRequests.append(friend)
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.requests.count
        }
        else {
            return self.sentRequests.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)
        
        // Requests sent to me
        if indexPath.section == 0 {
            let request = self.requests[indexPath.row]
            cell.textLabel?.text = request.requesterName
            cell.detailTextLabel?.text = request.date
        }
        
        // Requests sent by me
        if indexPath.section == 1 {
            let friend = self.sentRequests[indexPath.row]
            cell.textLabel?.text = friend.name
            cell.detailTextLabel?.text = friend.status
        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let alertController = UIAlertController(title: "Friend...or not friend?", message: "Decline or Acccept the request", preferredStyle:    UIAlertControllerStyle.alert)
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
            let declineAction = UIAlertAction(title: "Decline", style: .default) { (_) -> Void in
                print("DECLINE")
                // Remove from current user requests
                ref.child("profiles").child(self.currentUserId!).child("requests").child(self.requests[indexPath.row].requesterUid!).removeValue()
            
                // Update status on sender to 'declined'
                ref.child("profiles").child(self.requests[indexPath.row].requesterUid!).child("friends").child(self.currentUserId!).child("status").setValue("declined")
            
            
                if let index = self.requests.index(of: self.requests[indexPath.row]) {
                    self.requests.remove(at: index)
                }
            
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            
            }
            let acceptAction = UIAlertAction(title: "Accept", style: .default) { (_) -> Void in
                print("Request Accepted")
                // Add requested user to friends list
                let friend = Friend()
                friend.name = self.requests[indexPath.row].requesterName
                friend.friendUid = self.requests[indexPath.row].requesterUid
                friend.status = "Accepted"
                let friendData = ["friend_uid": friend.friendUid, "name": friend.name, "status": friend.status]
                ref.child("profiles").child(self.currentUserId!).child("friends").child(friend.friendUid!).setValue(friendData)
            
                ref.child("profiles").child(self.currentUserId!).child("requests").child(self.requests[indexPath.row].requesterUid!).removeValue()
            
                // Update status on requester
                ref.child("profiles").child(friend.friendUid!).child("friends").child(self.currentUserId!).child("status").setValue("Accepted")
            
                if let index = self.requests.index(of: self.requests[indexPath.row]) {
                    self.requests.remove(at: index)
                }
            
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        
            alertController.addAction(declineAction)
            alertController.addAction(acceptAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return tableHeader[0]
        }
        else {
            return tableHeader[1]
        }
    }
    

}
