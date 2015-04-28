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
    let socket = SocketIOClient(socketURL: "localhost:8080")
    
    // Crowd Data
    var crowd : Crowd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tbvc = self.tabBarController as CrowdTabViewController
        crowd = tbvc.myCrowd

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // code connecting
        self.addHandlers()
        self.socket.connect()
//        self.socket.emit("test");
    }
    
    func addHandlers() {
        // Using a shorthand parameter name for closures
        self.socket.onAny {println("Got event: \($0.event), with items: \($0.items)")}
        
        self.socket.on("voted") {[weak self] data, ack in
            print("voted!")
            return
        }
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pendingSongCell", forIndexPath: indexPath) as PendingSongCell

        // Configure the cell...
        var currentSong = self.crowd!.pending.songs[indexPath.row]
        cell.songLabel.text = currentSong.name
        cell.votesLabel.text = String(currentSong.upvotes)
        cell.upvoteBttn.tag = indexPath.row
        cell.downvoteBttn.tag = indexPath.row
        
        // Creates Button Action Listeners
        cell.upvoteBttn.addTarget(self, action: "upvote:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.downvoteBttn.addTarget(self, action: "downvote:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }

    // When Upvote Button pressed: Upvote song at cell index
    func upvote(sender:UIButton!) {
        crowd?.upvotePendingSong(sender.tag)
        self.tableView.reloadData()
        
        //send vote over socket
        print("upvote")
        self.socket.emit("upVote", 2)
        self.socket.emit("fromClient")
    }
    
    // When Downvote Button Pressed: Downvote song at cell index
    func downvote(sender:UIButton!) {
        crowd?.downvotePendingSong(sender.tag)
        self.tableView.reloadData()
        
        //send vote over socket
        print("downvote")
        self.socket.emit("downVote", 2)
        self.socket.emit("fromClient")
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
