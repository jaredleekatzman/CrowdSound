//
//  Socket.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/29/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

class Socket {
    
    private var serverAddress = "54.152.114.46"
    var socketIO : SocketIOClient
    
    class var currentSocket: Socket {
        get  {
            struct Singleton {
                static let instance = Socket(address: "54.152.114.46")
            }
            return Singleton.instance
        }
    }
    
    init(address: String) {
        socketIO = SocketIOClient(socketURL: address)
        self.addHandlers()
        socketIO.connect()
    }
    
    func addHandlers() {
        
        //chat messages because why not:
        socketIO.on("updated playlists") {[weak self] data, ack in
            let json = JSON(data!)
            JSONDeserializer.deserializePlaylist(json)
            print("I got a PLAYLIST UPDATE!!")
            return
        }
        
        socketIO.on("updated pendings") {[weak self] data, ack in
            let json = JSON(data!)
            JSONDeserializer.deserializePending(json)
            print("I got a PENDING UPDATE!!")
            return
        }
        
        socketIO.on("updated crowds") {[weak self] data, ack in
            print("I got a Crowd UPDATE!!")
            let json = JSON(data!)
            JSONDeserializer.deserializeCrowdsList(json)
            return
        }



        // Using a shorthand parameter name for closures
        socketIO.onAny {println("Got event: \($0.event), with items: \($0.items)")}
        
        socketIO.on("voted") {[weak self] data, ack in
            print("voted!")
            return
        }
    }
    
}

