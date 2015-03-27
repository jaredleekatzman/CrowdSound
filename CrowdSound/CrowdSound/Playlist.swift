//
//  Playlist.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation


class Playlist {
    var songs : [Song]
    
    init() {
        songs = []
    }
    
    // for testing - create default playlist 
    class func defaultPlaylist() -> Playlist {
        var playlist = Playlist()
        playlist.songs = [Song.defaultSong(id: "1"), Song.defaultSong(id: "2"), Song.defaultSong(id: "3")]
        return playlist
    }
    
    // for testing - create default pending playlist
    class func defaultPending() -> Playlist {
        var playlist = Playlist()
        playlist.songs = [Song.defaultSong(id: "_Pending1"), Song.defaultSong(id: "_Pending2"), Song.defaultSong(id: "_Pending3")]
        return playlist
    }
    
}