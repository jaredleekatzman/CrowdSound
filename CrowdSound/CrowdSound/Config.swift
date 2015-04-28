//
//  Config.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/7/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

// Important Constants to conncet to server and token swap service

import Foundation

// Your client ID
let kClientId = "0dee5b0872624363a1bf94df5961e148"

// Your applications callback URL
let kCallbackURL = "crowdsound://callback"

// The URL to your token swap endpoint
// If you don't provide a token swap service url the login will use implicit grant tokens, which means that your user will need to sign in again every time the token expires.

let kTokenSwapServiceURL = "http://localhost:1234/swap"

// The URL to your token refresh endpoint
// If you don't provide a token refresh service url, the user will need to sign in again every time their token expires.

let kTokenRefreshServiceURL = "http://localhost:1234/refresh"


let kSessionUserDefaultsKey = "SpotifySession"


// MARK: - Server Constants 

let serverURL = "54.152.114.46"
let localURL = "localhost:8080"