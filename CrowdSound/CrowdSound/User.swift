//
//  User.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/28/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

private let _currentUser = User()

protocol updateCrowdsList{
    // function call?
    func updateCrowds()
}

class User {
    
    var userDelegate:updateCrowdsList? = nil

    
    var name : String = ""
    var upvotedSongs = [String: [String]]()
    var uid = NSUUID().UUIDString
    var crowds : [Crowd] = [] {
        didSet{
            // update player when playlist changed.
            if let delegate = self.userDelegate {
                println("====================== INSIDE THE IF=======================")
                delegate.updateCrowds()
            }
        }
    }
    
    // create a singleton of the current user
    class var currentUser: User {
        get  {
            struct Singleton {
                static let instance = User()
            }
            return Singleton.instance
        }
    }
    
    // tests if song has already been upvoted 
    func canUpvote(crowdUID: String, songUID: String) -> Bool {
        // return if invalid UID 
        if crowdUID.isEmpty || songUID.isEmpty {
            return false
        }
        if let songs = upvotedSongs[crowdUID] { // has crowd
            if contains(songs, songUID) {       // has specific song
                return false
            }
        }
        return true
    }
    
    // upvotes a current song
    func upvoteSong(crowdUID: String, songUID: String) {
        if crowdUID.isEmpty || songUID.isEmpty {
            return
        }

        if var songs = upvotedSongs[crowdUID] {
            songs.append(songUID)
            upvotedSongs[crowdUID] = songs
        }
        else { // Create the list
            upvotedSongs[crowdUID] = [songUID]
        }
    }
    
    // add a crowd to the crowds 
    func addCrowdToCrowds(crowd:Crowd) {
        crowds.append(crowd)
    }
    // downvotes a current song
    func downvoteSong(crowdUID: String, songUID: String) {
        if var songs = upvotedSongs[crowdUID] {
            songs = songs.filter { $0 != songUID }
            upvotedSongs[crowdUID] = songs
        }
        else {    // Should never get here?
            upvotedSongs[crowdUID] = []
        }
    }
}
