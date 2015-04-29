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
    var spotifyAlbumArtURL : NSURL?
    var upvotes : Int
    var uid : String
    
    
    init() {
        self.name = ""
        self.artist = ""
        self.upvotes = 0
        self.spotifyURI = NSURL(string: "nil")!
        self.spotifyAlbumArtURL = NSURL(string: "nil")!
        self.uid = NSUUID().UUIDString
    }

    init(name : String, artist : String, uri: NSURL, albumArt : NSURL? = nil) {
        self.name = name
        self.artist = artist
        self.spotifyURI = uri
        self.upvotes = 1
        self.uid = name + artist + NSUUID().UUIDString
        self.spotifyAlbumArtURL = albumArt
    }
    
    // For testing - create default song
    class func defaultSong(id : String = "") -> Song {
        // Testing: Song that is 12 seconds: "spotify:track:3GfZhVmn4nGqbuGG1be5ML"
        var SONGSARR = ["spotify:track:2YKcA5ZkWQfVHd7bMIv4iw", "spotify:track:2WMRd3xAb9FwXopCRNWDq1","spotify:track:4iEOVEULZRvmzYSZY2ViKN", "spotify:track:6BVBkKpZK09NmifUMZqj1z", "spotify:track:2mkv1b3dRFyiJ4Ybq31owf", "spotify:track:3vlVbJmvSm3x5Hqmnzh8HI"]
        var song = Song()
        song.name = "name" + id
        song.artist = "Jared Katzman"
        song.upvotes = Int(arc4random_uniform(6))
        song.spotifyURI = NSURL(string: SONGSARR[id.toInt() ?? 0])!
        return song 
    }
    
    // Increase the number of upvotes by 1
    func upvote() {
        self.upvotes++
    }
    
    // Decrease number of upvotes by 1
    // If SELF.UPVOTES is 0, do not decrease
    func downvote() {
        // Do not allow negative upvotes
        if (upvotes > 0) {
            self.upvotes--
        }
    }
}