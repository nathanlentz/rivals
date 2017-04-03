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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = FIRAuth.auth()?.currentUser?.displayName {
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
