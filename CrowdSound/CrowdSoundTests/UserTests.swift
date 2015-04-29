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
    
    func testUserIsSingleton() {
        let user = User.currentUser
        let user_two = User.currentUser
        assert(user.uid == user_two.uid, "User.currentUser should be singleton")
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
    
    func testCanUpvoteWithEmptyInput() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID = "SongUID"
        assert(!user.canUpvote("", songUID: songUID), "cannot take empty crowd input")
        assert(!user.canUpvote(crowdUID, songUID: ""), "cannot take empty song input")
    }
    
    func testCanUpvoteSong() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID = "SongUID"
        assert(user.canUpvote(crowdUID, songUID: songUID), "user should be able to upvote song if crowd and song not present")
    }
    
    func testCanUpvoteSongWithCrowd() {
        var user = User()
        let crowdUID = "CrowdUID"
        let dummySongUID = "dummySongUID"
        let songUID = "SongUID"
        
        user.upvoteSong(crowdUID, songUID: dummySongUID)
        assert(user.canUpvote(crowdUID, songUID: songUID), "user should be able to upvote song if song not present, but crowd is")
    }
    
    func testUpvoteSongTwice() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID = "SongUID"
        user.upvoteSong(crowdUID, songUID: songUID)
        assert(!user.canUpvote(crowdUID, songUID: songUID), "user should not be able to upvote song in crowd if already upvoted")
    }
    
    func testUpvoteSongEmptyInput() {
        var user = User()
        let crowdUID = "CrowdUID"
        let songUID = "SongUID"
        user.upvoteSong("", songUID: songUID)
        assert(user.upvotedSongs.count == 0, "cannot upvote song with empty crowd uid")
        user.upvoteSong(crowdUID, songUID: "")
        assert(user.upvotedSongs.count == 0, "cannot upvote song with empty song uid ")

    }
}
