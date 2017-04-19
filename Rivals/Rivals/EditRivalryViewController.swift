//
//  EditRivalryViewController.swift
//  Rivals
//
//  Created by Nate Lentz on 4/17/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit

class EditRivalryViewController: UIViewController {

    var rivalry = Rivalry()
    var newGameResult: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = rivalry.title
    }

    
    @IBAction func completeRivalryDidPress(_ sender: Any) {
        completeRivalry(rivalryId: self.rivalry.rivalryKey!)
        navigationController?.popViewController(animated: true)
    }
    
}

extension EditRivalryViewController : AddGameDelegate {
    func gameAdded(result: String){
        self.newGameResult = result
    }

}
