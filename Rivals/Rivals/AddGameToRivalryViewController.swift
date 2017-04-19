//
//  AddGameToRivalryViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/17/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Social

protocol AddGameDelegate {
    func gameAdded(result: String)
}

class AddGameToRivalryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerItems = ["Win", "Lose", "Draw"]
    var result: String = ""
    var delegate : AddGameDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        

    }
    
    
    @IBAction func addGameDidPress(_ sender: UIButton) {
        print(result)
        // Add game to rivalry and pass game to edit rivalry VC
        
        
        dismiss(animated: true, completion: nil)
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
