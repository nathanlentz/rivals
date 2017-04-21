//
//  HomeViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/3/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    var ref: FIRDatabaseReference!
    var currentUser = User()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var inProgressButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    // Reference for menu button
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = FIRDatabase.database().reference()
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        /* Theme Stuff */
        self.inProgressButton.backgroundColor = RIVALS_DARKGREY
        self.completedButton.backgroundColor = RIVALS_DARKGREY
        
        checkIfUserIsLoggedIn()
    
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            ref.child("profiles").child(uid!).observe(.value, with: { (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dict["name"] as? String
                    self.currentUser.name = dict["name"] as? String
                    self.currentUser.email = dict["email"] as? String
                    self.currentUser.wins = dict["wins"] as? Int
                    self.currentUser.losses = dict["losses"] as? Int
                    self.currentUser.followers = dict["followers"] as? [String]
                    self.currentUser.following = dict["following"] as? [String]
                    self.winsLabel.text = String(self.currentUser.wins!)
                    self.lossesLabel.text = String(self.currentUser.losses!)
                    if let userProfileImageUrl = dict["profileImageUrl"] as? String{
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: userProfileImageUrl)
                    }
//                  self.followersLabel.text = String(self.currentUser.followers!.count) + "Followers"
//                  self.followingLabel.text = String(self.currentUser.following!.count) + "Following"
                    //self.gamesPlayedLabel.text = String(self.currentUser.wins! + self.currentUser.losses!) + "Games Played"
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    func updateHomeView(){
        //        self.winsLabel.text = String(self.currentUser.wins!)
        //        self.lossesLabel.text = String(self.currentUser.losses!)
    }
    
 

}
