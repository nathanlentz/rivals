//
//  MenuViewController.swift
//  
//
//  Created by Nate Lentz on 4/12/17.
//  Custom view for the menu drawer
//

import UIKit
import Firebase

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Create Firebase ref
    var ref: FIRDatabaseReference!
    
    // Array for storing menu item labels
    var menuNames:Array = [String]()
    // Array for storing menu item images
    var menuItemImage:Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Drawer Menu Items
        menuNames = ["Profile", "Home", "Search Users", "Logout"]
        
        // Get name of current user
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
    
        if cell.labelMenuName.text! == "Profile" {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
            let newFrontVC =  UINavigationController.init(rootViewController:vc)
            revealViewController.pushFrontViewController(newFrontVC, animated: true)
        }
        
        if cell.labelMenuName.text! == "Home"{
            
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
            let newFrontVC =  UINavigationController.init(rootViewController:vc)
            revealViewController.pushFrontViewController(newFrontVC, animated: true)
        }
        
        if cell.labelMenuName.text! == menuNames[2] {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "searchVC") as! FindUsersViewController
            let newFrontVC =  UINavigationController.init(rootViewController:vc)
            revealViewController.pushFrontViewController(newFrontVC, animated: true)
        }
        
        if cell.labelMenuName.text! == "Logout" {
            
            // execute logout
            do {
                try FIRAuth.auth()?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
