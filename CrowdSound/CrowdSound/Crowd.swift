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
//    var player : SPTAudioStreamingController
    var currentTrackIndex : Int
    var isPrivate: Bool     // if need password
    var password: String    // what the password is
    
    init() {
        name = ""
        playlist = Playlist()
        pending = Playlist()
        host = ""
        threshold = 0
        guests = []
        currentTrackIndex = -1
        isPrivate = false
        password = ""
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
        crowd.currentTrackIndex = 0
        return crowd
    }
    
    func upvotePendingSong(songIndex:Int) {
        pending.upvoteSong(songIndex)
        if (pending.top().upvotes >= threshold) {
            playlist.addSong(pending.pop())
        }
    }
    func downvotePendingSong(songIndex:Int) {
        pending.downvoteSong(songIndex)
    }
}