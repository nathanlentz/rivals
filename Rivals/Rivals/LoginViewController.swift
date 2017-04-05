//
//  LoginViewController.swift
//  Rivals
//
//  Created by lentzna on 3/23/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController : UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    var validationErrors = ""
    
    var firebaseRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.placeholder = "Email_Text".localized
        PasswordTextField.placeholder = "Password_Text".localized
        
        firebaseRef = FIRDatabase.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Functions */

    @IBAction func loginDidPress(_ sender: UIButton) {
        if(self.EmailTextField.text == "" || self.PasswordTextField.text == ""){
            
            // TODO remove alert for validation on text fields
            let alertController = UIAlertController(title: "Error", message: "Please enter email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            FIRAuth.auth()?.signIn(withEmail: self.EmailTextField.text!, password: self.PasswordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("User logged in")
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC")
                    self.present(vc, animated: true, completion: nil)
                }
                    
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }


    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
