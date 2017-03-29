//
//  RegisterViewController.swift
//  Rivals
//
//  Created by X Code User on 3/29/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Image Picker
        picker.delegate = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Actions */
    @IBAction func selectImage(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }

    @IBAction func registerButton(_ sender: Any) {
        if validateFields(){
            // Create our user in Firebase
            createUser()
        }
    }
    
    /* Functions */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // check if image exists
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
        }
        // Dismiss image picker
        self.dismiss(animated: true, completion: nil)
    }
    
    // Ensure user information is valid
    func validateFields() -> Bool {
        guard nameField.text != "", emailField.text != "", passwordField.text != "", confirmField.text != ""
            else { return false }
        
        if passwordField.text != confirmField.text {
            // TODO: Impelement validate visibility stuff
            print("Passwords do not match")
        }
        
        return true
    }
    
    // Create Firebase User
    func createUser(){
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user: FIRUser?, error) in
            if error == nil {
                print("User created!")
            }
            else {
                print("FAILUREEEE")
            }
        })
    }
    
    
}
