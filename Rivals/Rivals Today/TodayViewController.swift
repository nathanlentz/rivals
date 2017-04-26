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
        
//        if let dataFromApp = UserDefaults.init(suiteName: "group.rivalsntnl")?.value(forKey: "dataArray") {
//            self.WinsLabel.text = dataFromApp as? [String]
//        }
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        if let dataFromApp = UserDefaults.init(suiteName: "group.rivalsntnl")?.value(forKey: "dataArray") {
            if let dataArray = dataFromApp as? [String] {
                if dataArray[0] != self.WinsLabel.text {
                    self.WinsLabel.text = dataArray[0]
                    
                    completionHandler(NCUpdateResult.newData)
                }
                if dataArray[1] != self.LossesLabel.text {
                    self.LossesLabel.text = dataArray[1]
                    completionHandler(NCUpdateResult.newData)
                }
                else {
                    completionHandler(NCUpdateResult.noData)
                }
            }

            else {
                completionHandler(NCUpdateResult.noData)
            }
        }
        
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
