//
//  Song.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

class Song {
    var name : String
    var spotifyID : String
//    var spotifyTrack : SPTTrack
    var upvotes : Int
    
    init() {
        self.name = ""
        self.spotifyID = ""
        self.upvotes = 0
//        self.spotifyTrack = nil
    }
    
//    init(track : SPPTrack) {
//        self.spotifyTrack = track
//        self.name =
//    }
//    
    // for testing - create default song
    class func defaultSong(id : String = "") -> Song {
        var song = Song()
        song.name = "name" + id
        song.spotifyID = "spotifyId" + id
        song.upvotes = Int(arc4random_uniform(6))
        return song 
    }
    
    func upvote() {
        self.upvotes++
    }
    
    func downvote() {
        self.upvotes--
    }
}