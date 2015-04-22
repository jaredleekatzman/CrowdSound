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
        let song1 = Song(name: "Jubel", artist: "Klingande", uri: NSURL(string: "spotify:track:2mpsKeLCbdXkwEpZRNi4XD")!)
        let song2 = Song(name: "Punga", artist: "Klingande", uri: NSURL(string: "spotify:track:1zKL8G85Yx3T9Q84TuOCSL")!)
        let song3 = Song(name: "Elevate", artist: "St. Lucia", uri: NSURL(string: "spotify:track:5BxVRqpZi6tIhAap1ZjzVD")!)
        
        playlist.songs = [song1, song3, song2]
        //        playlist.songs = [Song.defaultSong(id: "1"), Song.defaultSong(id: "2"), Song.defaultSong(id: "3")]
        return playlist
    }
    
    // for testing - create default pending playlist
    class func defaultPending() -> Playlist {
        var playlist = Playlist()
        
        let song1 = Song(name: "Bang Bang", artist: "Jessie J", uri: NSURL(string: "spotify:track:0puf9yIluy9W0vpMEUoAnN")!)
        let song2 = Song(name: "Price Tag", artist: "Jessie J", uri: NSURL(string: "spotify:track:5mvKuE9Lf9ARVXVXA32kK9")!)
        
        playlist.songs = [song1, song2]
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