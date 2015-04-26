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
    
    func testInitialization() {
        let playlist = Playlist()
        XCTAssertEqual(playlist.songs.count, 0, "initialize with no songs")
    }
    
    func testPendingUpvote() {
        var playlist = Playlist()
        playlist.songs = [Song()]
        let songVotes = playlist.songs[0].upvotes
        playlist.upvoteSong(0)
        XCTAssert(songVotes + 1 == playlist.songs[0].upvotes, "increased song upvotes by 1")
        
    }
    
    func testPlaylistPop() {
        let playlist = Playlist.defaultPlaylist()
        let pendingSong = playlist.songs[0]
        let nextSong = playlist.songs[1]
        XCTAssert(pendingSong === playlist.pop(), "pop returned correct song")
        XCTAssert(nextSong === playlist.top(), "pop removed the correct song")
    }

}
