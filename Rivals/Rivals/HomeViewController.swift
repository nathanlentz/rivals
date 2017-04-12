//
//  HomeViewController.swift
//  Rivals
//
//  Created by X Code User on 4/3/17.
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
        ref = FIRDatabase.database().reference()
        
        self.navigationItem.title = "NAME"
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
 

}
