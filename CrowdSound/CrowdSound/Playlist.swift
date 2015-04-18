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
        playlist.songs = sorted([Song.defaultSong(id: "_Pending1"), Song.defaultSong(id: "_Pending2"), Song.defaultSong(id: "_Pending3")]) {$0.upvotes > $1.upvotes}
        return playlist
    }
    // Return the number of songs in the playlist
    func count() -> Int {
        return self.songs.count
    }
    
    func getURIs() -> [NSURL] {
        return self.songs.map { a in a.spotifyURI }
    }
    
    
    func upvoteSong(songIndex:Int) {
//        println("Upvoting: \(songs[songIndex])")
        
        songs[songIndex].upvote()
        
        // Re-sort playlist
        // @todo: Make more efficient by using a sorting algorithm better for presorted lists
        songs = sorted(songs) { $0.upvotes > $1.upvotes}
    }
    func downvoteSong(songIndex:Int) {
        songs[songIndex].downvote()
        
        // Re-sort playlist
        // @todo: Make more efficient by using a sorting algorithm better for presorted lists
        songs = sorted(songs) {$0.upvotes > $1.upvotes }
    }
    func addSong(song:Song) {
        songs.append(song)
    }
    func isEmpty() -> Bool {
        if (songs.count > 0) {
            return false
        }
        return true
    }
    // TOP() returns the first song in the playlist. If the playlist is empty return nothing
    func top() -> Song {
            return songs[0]
    }
    // POP() removes the first song in the playlist and returns it
    func pop() -> Song {
        return songs.removeAtIndex(0)
    }
    
}