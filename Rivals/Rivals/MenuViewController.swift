//
//  MenuViewController.swift
//  
//
//  Created by X Code User on 4/12/17.
//
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Array for storing menu item labels
    var menuNames:Array = [String]()
    // Array for storing menu item images
    var menuItemImage:Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Drawer Menu Items
        menuNames = ["Home", "Settings", "Logout"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        //cell.imgIcon.image = menuItemImage[indexPath.row]
        cell.labelMenuName.text! = menuNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        if cell.labelMenuName.text! == "Home"{
            
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
            let newFrontVC =  UINavigationController.init(rootViewController:vc)
            revealViewController.pushFrontViewController(newFrontVC, animated: true)
        }
        
        if cell.labelMenuName.text! == "Logout" {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
            // execute logout
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
