//
//  FirebaseService.swift
//  Rivals
//
//  Created by Nate Lentz on 4/16/17.
//  Copyright © 2017 ntnl.design. All rights reserved.
//
//  This service should be used to pull all "Firebase" usage out of the view controllers
//

import Foundation
import Firebase

var ref = FIRDatabase.database().reference()


func createUserInDatabase(uid: String, userInfo: [String : Any]) {
    
    ref.child("profiles").child(uid).setValue(userInfo)
    
}


/**
Return an array of all users within the Firebase Database
 */
func getAllUsers() -> Array<User> {
    var users = [User]()
    ref.child("profiles").observe(.childAdded, with: { (snapshot) in
    
        if let dict = snapshot.value as? [String: AnyObject] {
            let user = User()
            user.name = dict["name"] as? String
            user.email = dict["email"] as? String
            user.wins = dict["wins"] as? Int
            user.losses = dict["losses"] as? Int
            user.uid = dict["uid"] as? String
            
            users.append(user)
        }
    
    }) { (error) in
        print(error.localizedDescription)
    }
    
    return users
}


/**
 Return an array of all rivalries
 */
func getAllRivalries() -> Array<Rivalry> {
    let rivalries = [Rivalry]()
    // TODO: Implement all the things
    return rivalries
}


/**
 Attepts to POST a new rivalry to firebase
 */
func createNewRivlary(creatorId: String, gameName: String, players: [String]) -> Bool {
    var success = true
    let key = ref.child("rivalries").childByAutoId().key
    
    
    // TODO: Add init for historical data
    let rivalryInfo: [String : Any] = ["rivalry_key": key, "creator_id": creatorId, "game_name": gameName, "players": players, "In Progress": true]
    
    ref.updateChildValues(["profiles/\(creatorId)/rivalries_in_progress": rivalryInfo, "rivalries/\(key)": rivalryInfo], withCompletionBlock: { (error) in
        print(error)
        success = false
    })
    
    return success
}

/**
 Attepts to GET all rivalries from firebase given a uid
 */
func getRivalry(userId: String) -> Array<Rivalry> {
    let rivalries = [Rivalry]()
    
    // TODO: getAllRivalries()
    // Filter all rivalries by those who have creator id of passed in id
    
    return rivalries
    
}

/**
 Attepts to GET all in progress rivalries from firebase given a uid
 */
func getInProgressRivalries(userId: String) -> Array<Rivalry> {
    let rivalries = [Rivalry]()
    
    // TODO: getAllRivalries()
    // Filter all rivalries that are "In Progress" by a user
    
    return rivalries
    
}

/**
 Attepts to GET all finished rivalries from firebase given a uid
 */
func getFinishedRivalries(userId: String) -> Array<Rivalry> {
    let rivalries = [Rivalry]()
    
    // TODO: getAllRivalries()
    // Filter all rivalries that are "finished" by a user
    
    return rivalries
}

/**
 Update an existing rivalry
 */
func updateRivalry(rivalryId: String, rivalryStatus: Bool, winnerIds: [String]) {
    
}






