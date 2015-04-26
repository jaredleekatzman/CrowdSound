//
//  PlaylistTests.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/1/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit
import XCTest

class PlaylistTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test if initialization works
    func testInitialization() {
        let playlist = Playlist()
        XCTAssertEqual(playlist.songs.count, 0, "initialize with no songs")
    }
    
    
    // Check if upvoting a song succeeds
    func testPendingUpvote() {
        var playlist = Playlist()
        playlist.songs = [Song()]
        let songVotes = playlist.songs[0].upvotes
        playlist.upvoteSong(0)
        XCTAssertEqual(songVotes + 1,playlist.songs[0].upvotes, "increased song upvotes by 1")
    }
    
    // Check upvoting Song Out Of Bounds
    func testPendingUpvoteSOOB() {
        var playlist = Playlist()
        playlist.songs = [Song()]
        playlist.upvoteSong(1)
        XCTAssert(true, "no error thrown")
    }
    
    // Check upvoting sorts correctly. After upvoting playlist should be sorted in decreasing order of upvotes
    func testUpvoteSorts() {
        var playlist = Playlist()
        var song1 = Song()
        var song2 = Song()
        playlist.songs = [song1, song2]
        playlist.upvoteSong(1)
        // Song 2 should have more upvotes than Song 1
        XCTAssert(playlist.songs[0] === song2, "song2 is first index")
        XCTAssert(playlist.songs[1] === song1, "song1 is second index")
    }
    
    // Checks if downvoting sorts correctly. After downvoting, playlist should be sorted in decreasing order of downvotes
    func testDownvoteSorts() {
        var playlist = Playlist()
        var song1 = Song()
        song1.upvotes = 2
        var song2 = Song()
        song2.upvotes = 2
        playlist.songs = [song1, song2]
        playlist.downvoteSong(0)
        // Song 2 should have more upvotes than Song 1
        XCTAssert(playlist.songs[0] === song2, "song2 is first index")
        XCTAssert(playlist.songs[1] === song1, "song1 is second index")
    }
    
    // Check if downvoting a song succeeds
    func testPendingDownvote() {
        var playlist = Playlist()
        playlist.songs = [Song()]
        // Set Song Votes to number greater than 0
        playlist.songs[0].upvotes = 5
        let songVotes = playlist.songs[0].upvotes
        playlist.downvoteSong(0)
        XCTAssertEqual(songVotes - 1,playlist.songs[0].upvotes, "decrease song upvotes by 1")
    }
    
    // Check downvoting Song Out Of Bounds
    func testPendingDownvoteSOOB() {
        var playlist = Playlist()
        playlist.songs = [Song()]
        playlist.downvoteSong(1)
        XCTAssert(true, "no error thrown")
    }
    
    // Check if Playlist.isEmpty() returns correctly
    func testPlaylistIsEmpty() {
        let playlist = Playlist()
        XCTAssertTrue(playlist.isEmpty(), "playlist is empty")
    }
    
    // Check Playlist.getURIs returns each song's URI
    func testGetURIs() {
        let playlist = Playlist.defaultPlaylist()
        let URIs = playlist.getURIs()
        for var index = 0; index < playlist.count(); index++ {
            XCTAssert(URIs[index] === playlist.songs[index].spotifyURI, "song \(index) URI returned correctly")
        }
    }
    
    // Check Playlist.getURIs on an empty playlist
    func testGetURIsOnEmpty() {
        let playlist = Playlist()
        XCTAssertEqual(playlist.getURIs().count, 0, "getURIs() returned no songs")
    }
    
    // Check if playlist adds a song correctly
    func testAddSong() {
        let playlist = Playlist.defaultPlaylist()
        let count = playlist.count()
        let song = Song()
        playlist.addSong(song)
        XCTAssert(playlist.songs[count] === song, "added song correctly")
    }

    // Test if Popping returns the correct song
    func testPlaylistPopReurn() {
        let playlist = Playlist.defaultPlaylist()
        let pendingSong = playlist.songs[0]
        let nextSong = playlist.songs[1]

        XCTAssert(pendingSong === playlist.pop(), "pop returned correct song")
    }
    
    // Test if Poping a Playlist Removes the first item
    func testPlaylistPopRemove() {
        let playlist = Playlist.defaultPlaylist()
        let pendingSong = playlist.songs[0]
        let nextSong = playlist.songs[1]
        playlist.pop()
        XCTAssert(nextSong === playlist.top(), "pop removed the correct song")
    }
    
    // Test if Playlist.TOP() returns correct song
    func testTop() {
        let playlist = Playlist.defaultPlaylist()
        let song = playlist.songs[0]
        XCTAssert(song === playlist.top(), "top returns correct songs")
    }
    
    // Check that Top returns NIL for an empty playlist
    func testTopEmptyPlaylist() {
        let playlist = Playlist()
        XCTAssertNil(playlist.top(), "Top should return nil on empty playlist")
    }
}
