//
//  ProfileViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/15/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var user = User()
    var imageUpdated = false
    var profileUpdated = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        self.errorLabel.text = ""
        
        getCurrentUserInfo()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    /* Get Current User Information and populate */
    func getCurrentUserInfo() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("profiles").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                self.user.name = dict["name"] as? String
                self.user.email = dict["email"] as? String
                self.user.uid = dict["uid"] as? String
                self.nameTextField.text = self.user.name
                self.emailTextField.text = self.user.email
                if let userProfileImageUrl = dict["profileImageUrl"] as? String{
                    self.profileImageView.loadImageUsingCacheWithUrlString(urlString: userProfileImageUrl)
                }
            }
            
        }, withCancel: nil)
    }
    
    /* Save Any Changes to user profile */
    @IBAction func saveButtonDidPress(_ sender: UIBarButtonItem) {
        
        if nameTextField.text != self.user.name! || emailTextField.text != self.user.email || self.imageUpdated {
            guard nameTextField.text != "", emailTextField.text != ""
                else { return }
            
            // Submit profile change request, update email/name
            let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
            changeRequest?.displayName = nameTextField.text
            changeRequest?.commitChanges(completion: { (error) in
                if error != nil {
                    print("Failed to update name")
                    self.errorLabel.text = "Failed to update profile"
                    self.profileUpdated = false
                }

            })
            FIRAuth.auth()?.currentUser?.updateEmail(emailTextField.text!, completion: { (error) in
                if error != nil {
                    self.errorLabel.text = "Failed to update profile"
                    self.profileUpdated = false
                }
                else {
                    // Send verification email
                    FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: nil)
                    // Pop an alert
                    
                }
            })
        
            if self.imageUpdated {
                // Compress image and upload new one, then set new image url
                let imgName = NSUUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("profile_images").child(imgName)
                if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) {
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        if let imageProfileUrl = metadata?.downloadURL()?.absoluteString {
                            self.user.profileImageUrl = imageProfileUrl
                            ref.child("profiles").child(self.user.uid!).child("profileImageUrl").setValue(self.user.profileImageUrl)
                        }
                    })
                }
            }
            
            if profileUpdated {
                ref.child("profiles").child(self.user.uid!).child("name").setValue(self.nameTextField.text)
                ref.child("profiles").child(self.user.uid!).child("email").setValue(self.emailTextField.text)
                
                // Pop alert that profile was updated
                let alertController = UIAlertController(title: "Success!", message: "Profile Updated!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
    
            
            else {
                let alertController = UIAlertController(title: "Error", message: "Could not update profile", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    
    /* Set up Image Picker */
    
    @IBAction func editImageDidPress(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
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
            self.profileImageView.image = selectedImage
            self.imageUpdated = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
