//
//  EditRivalryViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/17/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase
import Social


class EditRivalryViewController: UIViewController, AddGameDelegate, UITableViewDelegate, UITableViewDataSource {

    var ref: FIRDatabaseReference!
    var rivalry = Rivalry()
    var newGameResult: String = ""
    var currentUser = User()
    var wins = [Game]()
    var losses = [Game]()

    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentUser.uid = FIRAuth.auth()?.currentUser?.uid
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

        self.navigationItem.title = rivalry.title
        
        getWinsAndLosses()
    
    }

    @IBAction func shareDidPress(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "", message: "Share your rivalry", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.default) { (action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                // Set some default message
                twitterComposeVC?.setInitialText("I'm slaying this rivalry!")
                
                self.present(twitterComposeVC!, animated: true, completion: nil)
                
            }
            else {
                
                self.socialNotConfiguredAlert(message: "Dang. We can't tweet it out, you need to sign in through settings")
            }
        }
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func completeRivalryDidPress(_ sender: Any) {
        completeRivalry(rivalryId: self.rivalry.rivalryKey!)
        navigationController?.popViewController(animated: true)
    }
    
    func socialNotConfiguredAlert(message: String!){
        
        let alertController = UIAlertController(title: "Uh oh", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        
        alertController.addAction(settingsAction)
    
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getWinsAndLosses() {
        self.currentUser.uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("games").child(self.rivalry.rivalryKey!).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                if dict["player_id"] as? String == self.currentUser.uid {
                    let game = Game()
                    game.rivalry_id = dict["rivalry_id"] as? String
                    game.player_id = dict["player_id"] as? String
                    game.result = dict["result"] as? String
                    if game.result == "Win" {
                        self.appendWin(game: game)
                    }
                    else {
                        self.appendLoss(game: game)
                    }
                }
            }
        })
    }
    
    func appendWin(game: Game){
        self.wins.append(game)
        updateLabels()
    }
    
    func appendLoss(game: Game){
        self.losses.append(game)
        updateLabels()
    }
    
    func updateLabels() {
        self.winsLabel.text = String(self.wins.count)
        self.lossesLabel.text = String(self.losses.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGameSegue" {
            if let destVC = segue.destination as? AddGameToRivalryViewController {
                destVC.delegate = self
                destVC.rivalryId = self.rivalry.rivalryKey!
            }
        }
    }

    func gameAdded(result: String) {
        self.newGameResult = result
    }
    
    /* Table Setup */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = "TEST"
        return cell
    }
    
    
    
}
