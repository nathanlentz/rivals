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
    
    // Reference for menu button
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // If we arent authenticated, prompt login/register
            if user == nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = FIRDatabase.database().reference()
        
        let userID : String = (FIRAuth.auth()?.currentUser?.uid)!
        print("User ID: " + userID)
//        
//        self.ref?.child("users").child(userID).observeSingleEvent(of: .value, with: {(snapshot) in
//            
//            let userName = (snapshot.value as! NSDictionary)["full name"] as! String
//            print(userName)
//            
//            self.navigationItem.title = userName
//            
//        })
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
 

}
