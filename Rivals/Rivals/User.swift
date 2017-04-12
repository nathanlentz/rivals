//
//  User.swift
//  Rivals
//
//  Created by X Code User on 4/3/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    
    var userId: String!
    var fullName: String!
    var imagePath: String!
    var followerIds = [String]()
    var followsIds = [String]()
    
}
