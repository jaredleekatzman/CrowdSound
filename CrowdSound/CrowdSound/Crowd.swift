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
    
    // for testing: create dummy crowds
    class func createDummyCrowds() -> [Crowd] {
        
        var crowds = [Crowd]()
        
        var springFling = Crowd.defaultCrowd()
        springFling.name = "Spring Fling Playlist"
        springFling.isPrivate = true
        springFling.password = "spring fling"
        crowds.append(springFling)
        
        var defaultCrowd = Crowd.defaultCrowd()
        defaultCrowd.name = "Jack's Naptime Playlist"
        crowds.append(defaultCrowd)
        
        var eliCrowd = Crowd.defaultCrowd()
        eliCrowd.host = "Eli"
        eliCrowd.name = "Eli's on a boat!"
        eliCrowd.password = "eli"
        eliCrowd.isPrivate = true
        crowds.append(eliCrowd)
        
        var jaredCrowd = Crowd.defaultCrowd()
        jaredCrowd.name = "Jared's Fun Party"
        crowds.append(jaredCrowd)
        
        var timCrowd = Crowd.defaultCrowd()
        timCrowd.name = "Tim's Rockin' Party"
        crowds.append(timCrowd)
        
        var coding = Crowd.defaultCrowd()
        coding.name = "CPSC 365 Hangout"
        crowds.append(coding)
        
        var coding2 = Crowd.defaultCrowd()
        coding2.name = "Plug in to Code"
        crowds.append(coding2)
        
        var crowd1 = Crowd.defaultCrowd()
        crowd1.name = "Looking to boogy"
        crowds.append(crowd1)
        
        var crowd2 = Crowd.defaultCrowd()
        crowd2.name = "April 20th"
        crowds.append(crowd2)
        
        var crowd3 = Crowd.defaultCrowd()
        crowd3.name = "Goin' on a trip"
        crowds.append(crowd3)
        
        var crowd4 = Crowd.defaultCrowd()
        crowd4.name = "Skull n' Horns"
        crowds.append(crowd4)
        
        var crowd5 = Crowd.defaultCrowd()
        crowd5.name = "Noise Bans in New Haven"
        crowds.append(crowd5)
        
        var crowd6 = Crowd.defaultCrowd()
        crowd6.name = "Birthday Party Playlist"
        crowds.append(crowd6)
        
        crowds.append(defaultCrowd)
        
        return crowds
    }
    
    // Upvotes pending song at SONGINDEX. If upvotes exceed threshold move to PLAYLIST
    func upvotePendingSong(songIndex:Int) {
        pending.upvoteSong(songIndex)
        println("threshold")
        if (pending.top()?.upvotes >= threshold) {
            playlist.addSong(pending.pop())
        }
    }
    
    // Downvotes pending song at SONGINDEX
    func downvotePendingSong(songIndex:Int) {
        pending.downvoteSong(songIndex)
    }
}