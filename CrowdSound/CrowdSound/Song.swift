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
    var upvotes : Int
    
    init() {
        name = ""
        spotifyID = ""
        upvotes = 0
    }
    
    // for testing - create default song 
    class func defaultSong(id : String = "") -> Song {
        var song = Song()
        song.name = "name" + id
        song.spotifyID = "spotifyId" + id
        song.upvotes = 0
        return song 
    }
}