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
    var artist : String
    var spotifyID : String
    var spotifyURI : NSURL
    var upvotes : Int
    
    init() {
        self.name = ""
        self.artist = ""
        self.spotifyID = ""
        self.upvotes = 0
        self.spotifyURI = NSURL(string: "nil")!
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
        song.artist = "Jared Katzman"
        song.spotifyID = "spotifyId" + id
        song.upvotes = Int(arc4random_uniform(6))
        song.spotifyURI = NSURL(string: "spotify:track:4iEOVEULZRvmzYSZY2ViKN")!
        return song 
    }
    
    func upvote() {
        self.upvotes++
    }
    
    func downvote() {
        self.upvotes--
    }
}