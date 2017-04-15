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
    
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    
    
    var currentUser = User()
    
    // Reference for menu button
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = FIRDatabase.database().reference()
        
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
                    var tmpNum = dict["wins"] as! Int?
                    self.winsLabel.text! = String(tmpNum!)
                    tmpNum = dict["losses"] as! Int?
                    self.lossesLabel.text! = String(tmpNum!)
                    
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
