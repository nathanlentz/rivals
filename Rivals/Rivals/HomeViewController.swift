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
    @IBOutlet weak var requestButton: UIButton!
    
    // Reference for menu button
    @IBOutlet weak var friendsNumberLabel: UILabel!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        ref = FIRDatabase.database().reference()
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        /* Theme Stuff */
        self.inProgressButton.backgroundColor = RIVALS_PRIMARY
        self.completedButton.backgroundColor = RIVALS_PRIMARY
        self.requestButton.backgroundColor = RIVALS_BLUISH
        view.backgroundColor = RIVALS_SECONDARY
        
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
                    self.currentUser.friends = dict["friends"] as? [String : Any]
                    self.currentUser.requests = dict["requests"] as? [String : Any]
                    self.winsLabel.text = String(self.currentUser.wins!)
                    self.lossesLabel.text = String(self.currentUser.losses!)
                    if let userProfileImageUrl = dict["profileImageUrl"] as? String{
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: userProfileImageUrl)
                    }
                    
                    if self.currentUser.requests != nil {
                        self.requestButton.setTitle("Requests (\(self.currentUser.requests?.count ?? 0))", for: .normal)
                    }
                    
                    else {
                        self.requestButton.setTitle("Requests (0)", for: .normal)
                    }
                    
                    if self.currentUser.friends != nil {
                        self.friendsNumberLabel.text = "\(self.currentUser.friends?.count ?? 0)"
                    }

                    self.gamesPlayedLabel.text = String(self.currentUser.wins! + self.currentUser.losses!)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
 

}
