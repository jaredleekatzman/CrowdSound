//
//  JSONSerializer.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/29/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

class JSONSerializer {
    
    class func toJSON(dict: [String: AnyObject]) -> NSString {
        // return error if necessary
        var error:NSError?
        let data = NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions(0), error: &error)
        return NSString(data: data!, encoding: NSUTF8StringEncoding)!
    
    
    }
    
    
    class func serializeUpvote(crowdID: String, songID: String) -> [String: AnyObject]? {
        
        let dict = [
            "crowd_uid": NSString(string: crowdID),
            "song_uid": NSString(string: songID)
        ]
        
        if NSJSONSerialization.isValidJSONObject(dict) {
            println("can serialize upvote!")
            return dict
        }
        println("canNOT serialize upvote!")
        return nil
    }
    
//    class func serializeNewSongToPending(crowdID: String, songID: String, songURI: NSURL, albumArtURI: NSURL, artist: String) -> [String: AnyObject]? {
//        let dict = [
//            "crowd_uid": NSString(string: crowdID),
//            "song_uid": NSString(string: songID),
//            "song_artist" : NSString(string: artist),
//            "song_uri": NSString(string: songURI.absoluteString!),
//            "song_albumArtURI": NSString(string: albumArtURI.absoluteString!)
//        ]
//        
//        if NSJSONSerialization.isValidJSONObject(dict) {
//            println("can serialize newSong To Pendign!")
//            return dict
//        }
//        println("canNOT serialize new Song To Pending!")
//        return nil
//    }
    
    class func serializeNewSongToPending(crowdID: String, song: Song) -> [String: AnyObject]? {
        let dict = [
            "crowd_uid": NSString(string: crowdID),
            "song_uid": NSString(string: song.uid),
            "song_name": NSString(string: song.name), 
            "song_artist" : NSString(string: song.artist),
            "song_uri": NSString(string: song.spotifyURI.absoluteString!),
            "song_albumArtURI": NSString(string: song.spotifyAlbumArtURL.absoluteString!)
        ]
        
        if NSJSONSerialization.isValidJSONObject(dict) {
            println("can serialize newSong To Pendign!")
            return dict
        }
        println("canNOT serialize new Song To Pending!")
        return nil
    }
    
    class func seralizeJoinCrowd(userID: String, crowdID: String) -> [String: AnyObject]? {
        
        let dict = [
            "crowd_uid": NSString(string: crowdID),
            "user_uid": NSString(string: userID)
        ]
        
        if NSJSONSerialization.isValidJSONObject(dict) {
            println("can serialize join crowd!")
            return dict
        }

        println("canNOT serialize join crowd!")
        return nil
    }
    
    class func serializeNewCrowd(crowd: Crowd) -> [String: AnyObject]? {
        let dict = [
            "crowd_uid": NSString(string: crowd.uid),
            "crowd_name": NSString(string: crowd.name),
            "crowd_host": NSString(string: crowd.host),
            "crowd_password": NSString(string: crowd.password),
            "crowd_isPrivate": crowd.isPrivate,
            "crowd_threshold": NSNumber(integer: crowd.threshold)
        ]
        
        if NSJSONSerialization.isValidJSONObject(dict) {
            println("can serialize new crowd!")
            return dict
        }
        println("CANNOT serialize new crowd!")
        return nil
    }
}
