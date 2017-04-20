//
//  AddGameToRivalryViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/17/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Social
import Firebase

protocol AddGameDelegate {
    func gameAdded(result: String)
}

class AddGameToRivalryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var commentSection: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerItems = ["Win", "Lose", "Draw"]
    var result: String = "Win"
    var delegate : AddGameDelegate?
    var rivalryId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        pickerView.delegate = self
        pickerView.dataSource = self

    }
    
    @IBAction func exitButtonDidPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addResultButtonDidPress(_ sender: UIButton) {
        
        addGameToRivalry()
        dismiss(animated: true, completion: nil)
    }

    
    func addGameToRivalry(){
        let key = ref.child("games").child(self.rivalryId).childByAutoId().key
        let currentUserId = FIRAuth.auth()?.currentUser?.uid
        let gameData = ["rivalry_id": self.rivalryId, "player_id": currentUserId!, "result": self.result, "comments": self.commentSection.text] as [String : Any]
        
        ref.child("games").child(self.rivalryId).child(key).setValue(gameData)
        
        if self.result == pickerItems[0] {
            ref.child("profiles").child(currentUserId!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    let user = User()
                    user.wins = dict["wins"] as? Int
                    self.ref.child("profiles").child(currentUserId!).child("wins").setValue(user.wins! + 1)
                }
            })
            
        }
        
        else {
            ref.child("profiles").child(currentUserId!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    let user = User()
                    user.losses = dict["losses"] as? Int
                    self.ref.child("profiles").child(currentUserId!).child("losses").setValue(user.losses! + 1)
                }
            })
            
        }
    }

    /* Picker View Setup */
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.result = pickerItems[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

}
