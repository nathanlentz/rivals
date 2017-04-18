//
//  EditRivalryViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/17/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit

class EditRivalryViewController: UIViewController {

    var rivalry = Rivalry()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = rivalry.title
    }

    
    @IBAction func completeRivalryDidPress(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
