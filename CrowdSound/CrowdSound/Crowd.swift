//
//  Crowd.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

class Crowd {
    var name : String       // crowd name
    var playlist : Playlist // playlist songs
    var pending : Playlist  // pending songs
    var host : String       // host id
    var threshold : Int     // threshold to be upvoted
    var guests : [String]   // list of guests invited
    
    init() {
        name = ""
        playlist = Playlist()
        pending = Playlist()
        host = ""
        threshold = 0
        guests = []
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
        return crowd
    }
}