//
//  RegisterViewController.swift
//  Rivals
//
//  Created by X Code User on 3/29/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!

    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Actions */
    @IBAction func registerButton(_ sender: Any) {
        if validateFields(){
            // Create our user in Firebase
            createUser()
        }
    }
    
    @IBAction func returnToLogin(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    /* Functions */
    
    // Ensure user information is valid
    func validateFields() -> Bool {
        guard nameField.text != "", emailField.text != "", passwordField.text != "", confirmField.text != ""
            else { return false }
        
        if passwordField.text != confirmField.text {
            // TODO: Impelement validate visibility stuff
            print("Passwords do not match")
            return false
        }
        
        return true
    }
    
    // Create Firebase User
    func createUser(){
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                changeRequest.displayName = self.nameField.text!
                changeRequest.commitChanges(completion: nil)
                
                if let user = user {
                
                    let userInfo: [String : Any] = ["uid": user.uid, "full name":self.nameField.text!, "email": self.emailField.text!]
                        
                    self.ref.child("users").child(user.uid).setValue(userInfo)
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeNavVC")
                    self.present(vc, animated: true, completion: nil)
                }
                
                print("User created!")
            }
            else {
                print(error!)
            }
        })
    }
    
    
}
