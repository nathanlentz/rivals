//
//  LoginViewController.swift
//  Rivals
//
//  Created by lentzna on 3/23/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.placeholder = "Email_Text".localized
        PasswordTextField.placeholder = "Password_Text".localized
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Functions */

    
}


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
