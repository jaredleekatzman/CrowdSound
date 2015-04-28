//
//  CrowdTabViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class CrowdTabViewController: UITabBarController {
    
    // define socket.io in class
    let socket = SocketIOClient(socketURL: "localhost:8080")
    
    // Provides the Crowd and Player to the ViewControllers
    var myCrowd : Crowd?
    var player : SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: change default screen if host
        self.navigationItem.title = myCrowd?.name
        var settingsBtn : UIBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: "settingsBtnClicked:")
        self.navigationItem.rightBarButtonItem = settingsBtn
        self.selectedIndex = 1
        
        // code for socket.io
        self.addHandlers()
        self.socket.connect()
    }
    
    func addHandlers() {
        self.socket.on("test") {[weak self] data, ack in
            print("yo socket connected")
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    func settingsBtnClicked(sender:UIBarButtonItem!) {
        NSLog("clicked the settings btn!")
        self.performSegueWithIdentifier("GoToSettingsPage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToSettingsPage" {
            var secondScene = segue.destinationViewController as SettingsTableViewController
            secondScene.myCrowd = myCrowd!
        }
    }
    
    // When Leaving a Crowd: stop the music player
    override func willMoveToParentViewController(parent: UIViewController?) {
        let auth = SPTAuth.defaultInstance()
        
        if player != nil {
            self.player?.stop({ (error:NSError!) -> Void in
                NSLog("Stopped player")
            })
        }
    }
}
