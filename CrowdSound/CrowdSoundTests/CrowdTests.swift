//
//  CrowdTests.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/2/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit
import XCTest

class CrowdTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test Default Initializer
    func testInit() {
        let crowd = Crowd()
        XCTAssertEqual(crowd.name, "", "Crowd name is empty")
        XCTAssertEqual(crowd.playlist.count(), 0, "Crowd Playlist is empty")
        XCTAssertEqual(crowd.pending.count(), 0, "Crowd Pending is empty")
        XCTAssertEqual(crowd.threshold, 0, "Crowd threshold is 0")
        XCTAssertEqual(crowd.guests.count, 0, "Crowd guest list is empty")
        XCTAssertEqual(crowd.host, "", "Crowd host is noone")
        XCTAssertEqual(crowd.isPrivate, false, "Crowd is public")
        XCTAssertEqual(crowd.password, "",  "Crowd does not have a password")
    }
    
    // Test if Upvoting a song below threshold works
    func testUpvotingPendingSong() {
        var crowd = Crowd()
        crowd.threshold = 20
        crowd.pending.addSong(Song())
        let songVotes = crowd.pending.songs[0].upvotes
        crowd.upvotePendingSong(0)
        XCTAssertEqual(crowd.pending.songs[0].upvotes, songVotes + 1, "Upvoted first song")
    }
    
    // Test if Upvoting a song past threshold correct moves the song between playlist
    func testUpvotingSongThreshold() {
        var crowd = Crowd()
        let song1 = Song()
        crowd.pending.addSong(song1)
        crowd.threshold = 1
        crowd.upvotePendingSong(0)
        XCTAssertTrue(crowd.pending.isEmpty(), "Pending playlist should be empty")
        XCTAssert(crowd.playlist.songs[0] === song1, "Song 1 moved to Playlist")
    }
    
    // Test that no error after upvoting a Song Out Of Bounds (SOOB)
    func testUpvotePendingSOOB() {
        let crowd = Crowd()
        crowd.upvotePendingSong(1)
        // If error cannot get here
        XCTAssert(true)
    }
    
    // Test basic functionality of downvoting pending
    func testDownvotingPending() {
        var crowd = Crowd.defaultCrowd()
        crowd.pending.songs[0].upvotes = 5
        let songVotes = crowd.pending.songs[0].upvotes
        crowd.downvotePendingSong(0)
        XCTAssertEqual(crowd.pending.songs[0].upvotes, songVotes - 1, "Downvoted first song")
    }
    
    // Test
    func testDownvotingPendingSOOB() {
        let crowd = Crowd()
        crowd.downvotePendingSong(1)
        // If error cannot get here
        XCTAssert(true)
    }

}
