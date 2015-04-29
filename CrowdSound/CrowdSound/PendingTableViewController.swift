//
//  PendingTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class PendingTableViewController: UITableViewController {
    
    // define socket.io in class
//    let socket = SocketIOClient(socketURL: "54.152.114.46/")
    
    // Crowd Data
    var crowd : Crowd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tbvc = self.tabBarController as? CrowdTabViewController {
            crowd = tbvc.myCrowd
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // WebSockets
        self.addHandlers()
//        self.socket.connect()
    }
    
    func addHandlers() {
        
        //chat messages because why not:
//        self.socket.on("chat message") {[weak self] data, ack in
//            print("I got a message!!")
//            return
//        }
//        // Using a shorthand parameter name for closures
//        self.socket.onAny {println("Got event: \($0.event), with items: \($0.items)")}
//        
//        self.socket.on("voted") {[weak self] data, ack in
//            print("voted!")
//            return
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return crowd!.pending.songs.count
    }
    
    func buttonPressed(button: UIButton!) {
        let songIndex = button.tag
        
        if let songUID = crowd?.pending.getSongUID(songIndex) {
            let crowdUID = crowd?.uid ?? ""
            if User.currentUser.canUpvote(crowdUID, songUID: songUID) {
                // User can Upvote!
                button.setImage(UIImage(named: "fullHeart"), forState: UIControlState.Normal)
//                button.enabled = false
                crowd?.upvotePendingSong(songIndex)
                User.currentUser.upvoteSong(crowdUID, songUID: songUID)
                self.tableView.reloadData()
                
                
                //send vote over socket
                print("upvote")
//                self.socket.emit("chat message", "this is a chat from the phone")
//                self.socket.emit("fromClient")
            }
            // User has already upvoted
            else {
                button.setImage(UIImage(named: "emptyHeart"), forState: UIControlState.Normal)
                crowd?.downvotePendingSong(songIndex)
                User.currentUser.downvoteSong(crowdUID, songUID: songUID)
                self.tableView.reloadData()
                
                //send vote over socket
                print("downvote")
//                self.socket.emit("downVote", 1)
//                self.socket.emit("fromClient")
            }
        }
    }
    
    // transform upvote button if already pressed
    func upvoteButtonAlreadyPressed(button: UIButton!)  {
        button.enabled = false
        button.setImage(UIImage(named: "fullHeart"), forState: UIControlState.Normal)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pendingSongCell", forIndexPath: indexPath) as PendingSongCell

        // Configure the cell...
        var currentSong = self.crowd!.pending.songs[indexPath.row]
        cell.songLabel.text = currentSong.name
        cell.artistLabel.text = currentSong.artist
        
        cell.votesLabel.text = String(currentSong.upvotes)
        cell.upvoteBttn.tag = indexPath.row

        
        let songIndex = indexPath.row
        
        if let songUID = crowd?.pending.getSongUID(songIndex) {
            let crowdUID = crowd?.uid ?? ""
            if User.currentUser.canUpvote(crowdUID, songUID: songUID) {
                cell.upvoteBttn.setImage(UIImage(named: "emptyHeart"), forState: UIControlState.Normal)
            }
            else {
                cell.upvoteBttn.setImage(UIImage(named: "fullHeart"), forState: UIControlState.Normal)
            }
        }
        
        // Creates Button Action Listeners
        cell.upvoteBttn.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)

        
        return cell
    }

    // When Upvote Button pressed: Upvote song at cell index
    func upvote(sender:UIButton!) {
        var songIndex: Int = sender.tag
        
        // if valid songUID
        if let songUID = crowd?.pending.getSongUID(songIndex) {
            let crowdUID = crowd?.uid ?? ""
            // if user can upvote the song, upvote it!
            if User.currentUser.canUpvote(crowdUID, songUID: songUID) {
                User.currentUser.upvoteSong(crowdUID, songUID: songUID)
                crowd?.pending.upvoteSong(songIndex)
                self.tableView.reloadData()

                //send vote over socket
                print("upvote")
//                self.socket.emit("chat message", "this is a chat from the phone")
//                self.socket.emit("fromClient")
            }
        }
    }
    
    // When Downvote Button Pressed: Downvote song at cell index
    func downvote(sender:UIButton!) {
        crowd?.downvotePendingSong(sender.tag)
        self.tableView.reloadData()
        
        //send vote over socket
        print("downvote")
//        self.socket.emit("downVote", 2)
//        self.socket.emit("fromClient")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
