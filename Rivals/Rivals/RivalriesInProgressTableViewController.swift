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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Rivalries In Progress"
        
        tableView.register(RivalryTableViewCell.self, forCellReuseIdentifier: "rivalryViewCell")
        
        getRivalriesInProgress()
    }
    
    
    @IBAction func doneButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getRivalriesInProgress() {
        ref.child("rivalries").observe(.childAdded, with: { (snapshot) in
            // Add users into array and use that to populate rows
            if let dict = snapshot.value as? [String: AnyObject] {
                let rivalry = Rivalry()
                rivalry.title = dict["game_name"] as? String
                rivalry.inProgress = dict["in_progress"] as? Bool
                rivalry.creatorId = dict["creator_id"] as? String
                rivalry.dateCreated = dict["creation_date"] as? String
                rivalry.rivalryKey = dict["rivalry_key"] as? String
                
                if FIRAuth.auth()?.currentUser?.uid == rivalry.creatorId && rivalry.inProgress == true{
                    self.rivalries.append(rivalry)
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rivalries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rivalryCell") as! RivalryTableViewCell
        
        let rivalry = rivalries[indexPath.row]
        cell.gameTitleLabel.text = rivalry.title!
        cell.dateLabel.text = "Rivalry Created: " + rivalry.dateCreated!
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "rivalryDetailSegue", sender: rivalries[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueVC = segue.destination as! EditRivalryViewController
        segueVC.rivalry = sender as! Rivalry
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    
    
    


}
