//
//  UserProfileViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/16/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user = User()
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text! = user.name!
        
        

    }



}
