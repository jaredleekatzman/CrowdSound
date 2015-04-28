//
//  User.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/28/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

private let _currentUser = User()

class User {
    
    var name : String = ""
    var id : String = ""
    var upvotedSongs = [String: [String]]()
    var uid = NSUUID().UUIDString
    
    // create a singleton of the current user
    class var currentUser: User {
        get  {
            struct Singleton {
                static let instance = User()
            }
            return Singleton.instance
        }
    }
    
    
}
