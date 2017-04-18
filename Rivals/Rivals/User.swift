//
//  User.swift
//  Rivals
//
//  Created by Nate Lentz on 4/3/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var uid: String?
    var name: String?
    var email: String?
    var wins: Int?
    var losses: Int?
    var profileImageUrl: String?
    var rivalriesInProgress: [String : Any]?
    var rivalriesCompleted: [String: Any]?
    var followers: [String : Any]?
    var following: [String : Any]?
    
}
