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
        
        self.rivalries = getInProgressRivalries(userId: (FIRAuth.auth()?.currentUser?.uid)!)
    }
    
    
    @IBAction func doneButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        cell.dateLabel.text = rivalry.dateCreated!
        for player in rivalry.players! {
            print(player.value)
        }
        
        return cell
    }
    
    
    
    
    


}
