//
//  TodayViewController.swift
//  Rivals Today
//
//  Created by Noah Taher on 4/22/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var WinsLabel: UILabel!
    @IBOutlet weak var LossesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func OpenRivalsAction(_ sender: Any) {
        
        let myAppURL = URL(string: "rivalsntnl:")!
        print(myAppURL)
        extensionContext?.open(myAppURL,
                               completionHandler: { (success) in
                               if (!success) {
                               print("error: failed to open app from Today Extension")
                }
        })
    }
}
