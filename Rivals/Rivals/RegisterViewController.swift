//
//  RegisterViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 3/29/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        
    }

    /* Actions */
    @IBAction func registerButton(_ sender: Any) {
        if validateFields(){
            // Create our user in Firebase
            createUser()
        }
    }
    
    @IBAction func returnToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Functions
     */
    
    
    // Handle tap on profile pic
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var imageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            imageFromPicker = editedImage
        }
        
        else if let originalImage  = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            imageFromPicker = originalImage
        }
        
        if let selectedImage = imageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
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
                
                // Generate unique string for naming in firebase storage
                let imgName = NSUUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("profile_images").child(imgName)
                
                // Compress to 10% of quality
                if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) {
    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        if let imageProfileUrl = metadata?.downloadURL()?.absoluteString {
                            if let user = user {
                                
                                let userInfo: [String : Any] = ["uid": user.uid, "name":self.nameField.text!, "email": self.emailField.text!, "wins": 0, "losses": 0, "profileImageUrl": imageProfileUrl]
                                
                                createUserInDatabase(uid: user.uid, userInfo: userInfo)
                                //self.ref.child("profiles").child(user.uid).setValue(userInfo)
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController")
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
            else {
                print(error!)
            }
        })
    }
    
    
}
