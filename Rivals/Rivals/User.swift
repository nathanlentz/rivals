//
//  User.swift
//  Rivals
//
//  Created by Nate Lentz on 4/3/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//

import UIKit
import Firebase


struct User {
    
    var userId: String!
    var fullName: String!
    var imagePath: String!
    var wins: Int!
    var losses: Int!
    var followerIds = [String]()
    var followsIds = [String]()
    
}
