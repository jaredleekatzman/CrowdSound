//
//  UserTests.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/28/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit
import XCTest

class UserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserInit() {
        let user = User()
        assert(user.name == "", "user name should be blank")
        assert(user.upvotedSongs.isEmpty, "upvoted songs should be empty") 
    }
    
    func testCanAddSong() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID = "SongUID"
        user.upvoteSong(crowdUID, songUID: songUID)
        println("what I want = \(user.upvotedSongs[songUID])")
        assert(user.upvotedSongs[crowdUID]! == [songUID], "Should only have one songUID")
    }
    
    func testAddingSongToNewCrowd() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID_one = "SongUID_one"
        let songUID_two = "SongUID_"
        user.upvoteSong(crowdUID, songUID: songUID_one)
        let songs = user.upvotedSongs[crowdUID]
        assert(songs!.count == 1, "Should only add one song when previously empty")
    }
    
    func testAddingSongToExistingCrowd() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID_one = "SongUID_one"
        let songUID_two = "SongUID_two"
        user.upvoteSong(crowdUID, songUID: songUID_one)
        user.upvoteSong(crowdUID, songUID: songUID_two)
        let songs = user.upvotedSongs[crowdUID]
        assert(songs!.count == 2, "Should have 2 songs in current crowd")

    }
    
    func testTrueCanUpvoteSong() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID = "SongUID"
        assert(user.canUpvote(crowdUID, songUID: songUID), "user should be able to upvote song if crowd and song not present")
    }
    
    func testTrueCanUpvoteSongWithCrowd() {
        var user = User()
        let crowdUID = "CrowdUID"
        let dummySongUID = "dummySongUID"
        let songUID = "SongUID"
        
        user.upvoteSong(crowdUID, songUID: dummySongUID)
        assert(user.canUpvote(crowdUID, songUID: songUID), "user should be able to upvote song if song not present, but crowd is")
    }
    
    
    func testFalseCanUpvoteSong() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID = "SongUID"
        user.upvoteSong(crowdUID, songUID: songUID)
        assert(!user.canUpvote(crowdUID, songUID: songUID), "user should not be able to upvote song in crowd if already upvoted")
    }

    // TEST SINGLETON 
    
    // TEST SONG IN ARRAY
    
    // TEST ADDING SONGS 
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}