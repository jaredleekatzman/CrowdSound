//
//  PendingTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class PendingTableViewController: UITableViewController {
    
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
    
    // transform upvote button if already pressed
    func upvoteButtonAlreadyPressed(button: UIButton!)  {
        button.enabled = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pendingSongCell", forIndexPath: indexPath) as PendingSongCell

        // Configure the cell...
        var currentSong = self.crowd!.pending.songs[indexPath.row]
        cell.songLabel.text = currentSong.name
        cell.votesLabel.text = String(currentSong.upvotes)
        cell.upvoteBttn.tag = indexPath.row
        
        // Creates Button Action Listeners
        cell.upvoteBttn.addTarget(self, action: "upvote:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // transforms button if upvote already clicked 
        if let songUID = crowd?.pending.getSongUID(indexPath.row) {
            let crowdUID = crowd?.uid ?? ""
            if !User.currentUser.canUpvote(crowdUID, songUID: songUID) {
                upvoteButtonAlreadyPressed(cell.upvoteBttn)
            }
        }
        
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
            }
        }

    }
    
    // When Downvote Button Pressed: Downvote song at cell index
    func downvote(sender:UIButton!) {
        crowd?.downvotePendingSong(sender.tag)
        self.tableView.reloadData()
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
