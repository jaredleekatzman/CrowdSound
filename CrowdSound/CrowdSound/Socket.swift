//
//  Socket.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/29/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import Foundation

class Socket {
    
    private var serverAddress = "localhost:8080"
    var socketIO : SocketIOClient
    
    class var currentSocket: Socket {
        get  {
            struct Singleton {
                static let instance = Socket(address: "localhost:8080")
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
        socketIO.on("chat message") {[weak self] data, ack in
            print("I got a message!!")
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

