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
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
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
        
        // Check if anything has changed
        // Submit profile change request
        // Update user info in profiles
        
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
            profileImageView.image = selectedImage
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
