//
//  JSONDeserializer.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/29/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

class JSONDeserializer {
    
    class func deserializePending(json: JSON) {
        for (label: String, pendingJson: JSON) in json {
            for (crowdUID: String, subJSON: JSON) in pendingJson {
                var pending = makePlaylist(subJSON)
                for (crowd: Crowd) in User.currentUser.crowds {
                    if crowd.uid == crowdUID {
                        println("updated crowd \(crowd.name) with new pending!!")
                        crowd.pending.songs = pending
                    }
                }
            }
        }
    }
    
    class func deserializePlaylist(json: JSON) {
        for (label: String, playlistsJson: JSON)  in json {
            for (crowdUID: String, subJSON: JSON) in playlistsJson {
                var playlist = makePlaylist(subJSON)
                for (crowd: Crowd) in User.currentUser.crowds {
                    if crowd.uid == crowdUID {
                        println("updated crowd \(crowd.name) with new playlist!!")
                        crowd.playlist.songs = playlist
                    }
                }
            }
        }
        
    }
    
    class func makePlaylist(json: JSON) -> [Song] {
        var songs : [Song] = []
        for (songID: String, songJSON: JSON) in json{
            var song = Song()
            song.artist = songJSON["artist"].stringValue
            song.name = songJSON["name"].stringValue
            song.uid = songJSON["uid"].stringValue
            song.upvotes = songJSON["upvotes"].intValue
            
            if let fileUrl = NSURL(string: songJSON["image"].stringValue) {
                song.spotifyAlbumArtURL = fileUrl
            }
            
            if let spotifyURL = NSURL(string: songJSON["spotifyURI"].stringValue) {
                song.spotifyURI = spotifyURL
            }
            
            // skip if null 
            if (song.artist.isEmpty || song.name.isEmpty) {
                continue
            }
            println("song deserialized, name = \(song.name), upvotes = \(song.upvotes), spot URI = \(song.spotifyURI)")

            songs.append(song)
        }
        return songs
    }
    
    class func deserializeCrowdsList(json: JSON) {
        
        for (label: String, crowdsJSON: JSON)  in json {
            
        
            var crowds : [Crowd] = []
        
            for (crowdID: String, crowdJSON: JSON) in crowdsJSON {
                var crowd = Crowd()
            
                crowd.uid = crowdJSON["crowdUID"].stringValue
                crowd.host = crowdJSON["hostUID"].stringValue
                crowd.isPrivate = crowdJSON["is_private"].boolValue
                crowd.name = crowdJSON["name"].stringValue
                crowd.password = crowdJSON["password"].stringValue
                crowd.threshold = crowdJSON["threshold"].intValue
                crowds.append(crowd)
                println("crowd deserialized = \(crowd.name), host = \(crowd.host), threshold = \(crowd.threshold)")
            }
            
            User.currentUser.crowds = crowds
        }
    }
    
}