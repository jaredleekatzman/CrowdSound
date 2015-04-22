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
    var spotifyURI : NSURL
    var upvotes : Int
    
    init() {
        self.name = ""
        self.artist = ""
        self.upvotes = 0
        self.spotifyURI = NSURL(string: "nil")!
    }

    init(name : String, artist : String, uri: NSURL) {
        self.name = name
        self.artist = artist
        self.spotifyURI = uri
        self.upvotes = 1
    }
    
    // for testing - create default song
    class func defaultSong(id : String = "") -> Song {
        // Song that is 12 seconds: "spotify:track:3GfZhVmn4nGqbuGG1be5ML"
        var SONGSARR = ["spotify:track:2YKcA5ZkWQfVHd7bMIv4iw", "spotify:track:2WMRd3xAb9FwXopCRNWDq1","spotify:track:4iEOVEULZRvmzYSZY2ViKN", "spotify:track:6BVBkKpZK09NmifUMZqj1z", "spotify:track:2mkv1b3dRFyiJ4Ybq31owf", "spotify:track:3vlVbJmvSm3x5Hqmnzh8HI"]
        var song = Song()
        song.name = "name" + id
        song.artist = "Jared Katzman"
        song.upvotes = Int(arc4random_uniform(6))
        song.spotifyURI = NSURL(string: SONGSARR[id.toInt() ?? 0])!
        return song 
    }
    
    func upvote() {
        self.upvotes++
    }
    
    func downvote() {
        self.upvotes--
    }
}