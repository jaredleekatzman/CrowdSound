//
//  Playlist.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

// protocol to use when playlist grows in playlistTableViewController.
protocol updateTracklistObserver{
    // function call?
    func updatePlayerTracklist()
}

class Playlist {
    var playlistDelegate:updateTracklistObserver? = nil
    
    var songs : [Song] {
        didSet{
            // update player when playlist changed.
            if let delegate = self.playlistDelegate {
                println("====================== INSIDE THE IF=======================")
                delegate.updatePlayerTracklist()
            }
        }
    }// playlist songs
    
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
        let song3 = Song(name: "Ruzica si bila, sada vise nisi", artist: "Bijelo Dugme", uri: NSURL(string: "spotify:track:7LRauMEYjaZ0mcMcxxymIJ")!)
        
        playlist.songs = [song1, song2]
        return playlist
    }
    // Return the number of songs in the playlist
    func count() -> Int {
        return self.songs.count
    }
    
    // Returns the SpotifyURIs for each song in the playlist
    func getURIs() -> [NSURL] {
        return self.songs.map { a in a.spotifyURI }
    }
    
    // If SONGINDX is a valid, upvote song at SONGINDEX and sorts playlist in decreasing upvote order
    // Otherwise do nothing
    func upvoteSong(songIndex:Int) {
        
        if songIndex < self.count() {
            songs[songIndex].upvote()
        
        // @todo: Make more efficient by using a sorting algorithm better for presorted lists
        songs = sorted(songs) { $0.upvotes > $1.upvotes}
        }
        else {
            NSLog("upvoting song out of bounds")
        }
    }
    
    // If SONGINDX is a valid, downvote song at SONGINDEX and sorts playlist in decreasing upvote order
    // Otherwise do nothing
    func downvoteSong(songIndex:Int) {
        
        if songIndex < self.count() {
            songs[songIndex].downvote()
            
            // @TODO: Write more efficient sorting algorithm for already sorted songs
            songs = sorted(songs) {$0.upvotes > $1.upvotes }
        }
        else {
            NSLog("downvoting song out of bounds")
        }
    
    }
    
    // Add SONG to the end of the playlist
    func addSong(song:Song) {
        songs.append(song)
    }
    
    // ISEMPTY() returns TRUE if the playlist has no .SONGS
    func isEmpty() -> Bool {
        if (songs.count > 0) {
            return false
        }
        return true
    }
    
    // TOP() returns the first song in the playlist. If the playlist is empty return nothing
    func top() -> Song? {
        if self.isEmpty() {
            return nil
        }
        return songs[0]
    }
    // POP() removes the first song in the playlist and returns it
    func pop() -> Song {
        return songs.removeAtIndex(0)
    }
    
}