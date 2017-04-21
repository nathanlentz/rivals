//
//  LoginViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 3/23/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController : UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var validationErrors = ""
    
    var firebaseRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailTextField.placeholder = "Email_Text".localized
        PasswordTextField.placeholder = "Password_Text".localized
        loginButton.layer.cornerRadius = 4
        signUpButton.layer.cornerRadius = 4
        
        firebaseRef = FIRDatabase.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }


    /* Functions */
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func loginDidPress(_ sender: UIButton) {
        if(self.EmailTextField.text == "" || self.PasswordTextField.text == ""){
            
            let alertController = UIAlertController(title: "Error", message: "Please enter email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            FIRAuth.auth()?.signIn(withEmail: self.EmailTextField.text!, password: self.PasswordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("User logged in")
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController")
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
