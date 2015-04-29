//
//  Crowd.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation



class Crowd : NSObject {
    var name : String       // crowd name
    var playlist : Playlist 
    var pending : Playlist  // pending songs
    var host : String       // host id
    var threshold : Int     // threshold to be upvoted
    var guests : [String]   // list of guests invited

    var isPrivate: Bool     // if need password
    var password: String    // what the password is
    var uid: String
    
    override init() {
        name = ""
        playlist = Playlist()
        pending = Playlist()
        host = ""
        threshold = 0
        guests = []
        isPrivate = false
        password = ""
        uid = NSUUID().UUIDString
    }
    
    init(givenName: String, givenHost: String) {
        name = givenName
        host = givenHost
        playlist = Playlist()
        pending = Playlist()
        threshold = 0
        guests = []
        isPrivate = false
        password = ""
        uid = givenName + givenHost + NSUUID().UUIDString
    }
    
    // for testing - create default crowd 
    class func defaultCrowd() -> Crowd {
        var crowd = Crowd()
        crowd.name = "Default Crowd"
        crowd.playlist = Playlist.defaultPlaylist()
        crowd.pending = Playlist.defaultPending()
        crowd.host = "Default Host"
        crowd.threshold = 7
        crowd.guests = ["Jack", "Jared", "Terin", "Eli", "TIM"]
        crowd.uid = NSUUID().UUIDString
        return crowd
    }
    
    // Upvotes pending song at SONGINDEX. If upvotes exceed threshold move to PLAYLIST
    func upvotePendingSong(songIndex:Int) {
        pending.upvoteSong(songIndex)
        if (pending.top()?.upvotes >= threshold) {
            playlist.addSong(pending.pop())
        }
    }
    
    // Downvotes pending song at SONGINDEX
    func downvotePendingSong(songIndex:Int) {
        pending.downvoteSong(songIndex)
    }
}