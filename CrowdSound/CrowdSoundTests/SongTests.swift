//
//  SongTests.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/1/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit
import XCTest

class SongTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Test Default Initializer
    func testDefaultInit() {
        let song = Song()
        XCTAssert(song.name.isEmpty, "song name should be empty")
        XCTAssert(song.artist.isEmpty, "song artist should be empty")
        XCTAssert(song.upvotes == 0, "song upvotes should = 0")
        XCTAssert(song.spotifyURI == NSURL(string: "nil"), "song url inits to nil")
    }
    
    // Test Initializer with Values
    func testInitWithValues() {
        let song = Song(name: "defaultName", artist: "defaultArtist", uri: NSURL(string: "spotify:track:4iEOVEULZRvmzYSZY2ViKN")!)
        XCTAssert(song.name == "defaultName", "song should have defaultName")
        XCTAssert(song.artist == "defaultArtist", "song artist should defaultArtist")
        XCTAssert(song.upvotes == 1, "song upvotes should = 1")
        XCTAssert(song.spotifyURI == NSURL(string: "spotify:track:4iEOVEULZRvmzYSZY2ViKN"), "song url init worked")
    }
    
    // Song Should increase number of upvotes
    func testBasicUpvote() {
        let song = Song()
        let numUpvotes = song.upvotes
        song.upvote()
        XCTAssert(song.upvotes == numUpvotes + 1, "should have increased by one")
    }
    
    // Test songs cannot have negative upvotes
    func testDownvoteBounds() {
        var song = Song()
        song.upvotes = 0
        song.downvote()
        XCTAssert(song.upvotes == 0, "should not downvote to negative number")
    }
    
    // Test if downvoting works
    func testBasicDownvote() {
        var song = Song()
        song.upvotes = 1 
        let numUpvotes = song.upvotes
        song.downvote()
        XCTAssert(song.upvotes == numUpvotes - 1, "should have decreased by one")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
