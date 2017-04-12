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
    
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
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
