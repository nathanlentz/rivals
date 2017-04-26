//
//  RivalriesInProgressTableViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/17/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class RivalriesInProgressTableViewController: UITableViewController {

    var rivalries = [Rivalry]()
    var rivalriesCreatedByOthers = [Rivalry]()
    var sectionHeaders = ["Created By Me", "Created By Others"]
    
    override func viewWillAppear(_ animated: Bool) {
        ref.child("rivalries").observe(.childChanged, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let rivalry = Rivalry()
                rivalry.title = dict["game_name"] as? String
                rivalry.inProgress = dict["in_progress"] as? Bool
                rivalry.creatorId = dict["creator_id"] as? String
                rivalry.dateCreated = dict["creation_date"] as? String
                rivalry.rivalryKey = dict["rivalry_key"] as? String
                rivalry.players = dict["players"] as? [String]
                
                if rivalry.inProgress == false{
                    var index: Int = 0
                    for i in 0...self.rivalries.count - 1 {
                        if rivalry.rivalryKey == self.rivalries[i].rivalryKey {
                            index = i
                        }
                    }
                    if index != -1 {
                        self.rivalries.remove(at: index)
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Rivalries In Progress"
                
        getRivalriesInProgress()
    }
    
    
    @IBAction func doneButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getRivalriesInProgress() {
        ref.child("rivalries").observe(.childAdded, with: { (snapshot) in
            // Add users into array and use that to populate rows
            if let dict = snapshot.value as? [String: AnyObject] {
                let uid = FIRAuth.auth()?.currentUser?.uid
                let rivalry = Rivalry()
                rivalry.title = dict["game_name"] as? String
                rivalry.inProgress = dict["in_progress"] as? Bool
                rivalry.creatorId = dict["creator_id"] as? String
                rivalry.dateCreated = dict["creation_date"] as? String
                rivalry.rivalryKey = dict["rivalry_key"] as? String
                rivalry.players = dict["players"] as? [String]
                
                if uid == rivalry.creatorId && rivalry.inProgress == true{
                    self.rivalries.append(rivalry)
                }
                
                // If you are included in players but are not the creator id, append rivalry to rivalriesNotCreatedByMe
                if uid != rivalry.creatorId && rivalry.players!.contains(uid!) {
                    self.rivalriesCreatedByOthers.append(rivalry)
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionHeaders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.rivalries.count
        }
        else {
            return self.rivalriesCreatedByOthers.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rivalryCell") as! RivalryTableViewCell
        
        if indexPath.section == 0 {
            let rivalry = rivalries[indexPath.row]
            cell.gameTitleLabel.text = rivalry.title!
            cell.dateLabel.text = "Rivalry Created: " + rivalry.dateCreated!
            
            for i in 0...rivalry.players!.count - 1 {
                ref.child("profiles").child(rivalry.players![i]).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String : Any] {
                        if !cell.playersLabel.text!.contains(dict["name"] as! String) {
                            cell.playersLabel.text! += "  \(dict["name"] as! String)  "
                        }
                    }
                })
            }
        }
        // Second section -
        else {
            let rivalry = rivalriesCreatedByOthers[indexPath.row]
            cell.gameTitleLabel.text = rivalry.title!
            cell.dateLabel.text = "Rivalry Created: " + rivalry.dateCreated!
            
            for i in 0...rivalry.players!.count - 1 {
                ref.child("profiles").child(rivalry.players![i]).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String : Any] {
                        if !cell.playersLabel.text!.contains(dict["name"] as! String) {
                            cell.playersLabel.text! += "  \(dict["name"] as! String)  "
                        }
                    }
                })
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "rivalryDetailSegue", sender: rivalries[indexPath.row])
        }
        
        else {
            performSegue(withIdentifier: "rivalryDetailSegue", sender: rivalriesCreatedByOthers[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueVC = segue.destination as! EditRivalryViewController
        segueVC.rivalry = sender as! Rivalry
    }
    


    
    
    
    
    


}
