//
//  PlaylistTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UITableViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {

    var crowd : Crowd?
    var playlist : Playlist?
    
    var player : SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as CrowdTabViewController
        crowd = tbvc.myCrowd
        playlist = crowd!.playlist

        
        
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
        
        return playlist!.songs.count
//        let currentTrackIndex = self.player?.currentTrackIndex ?? Int32(0)
//        let queueSize = playlist!.songs.count - Int(currentTrackIndex)
//        return queueSize
    }

    func playPause(sender : UIButton!) {
        let bool = self.player?.isPlaying ?? true
        self.player?.setIsPlaying(!bool, callback: nil)
        NSLog("Pressed Play/Pause")
    }
    
    func fastForward(sender : UIButton!) {
        NSLog("Next song")
        self.player?.skipNext(nil)
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            // custom cell
            let cell = tableView.dequeueReusableCellWithIdentifier("playerCell", forIndexPath: indexPath) as PlayerCell
            
            if playlist?.count() == 0 {
                cell.songLabel.text = ""
                cell.artistLabel.text = ""
                cell.backButton.enabled = false
                cell.playButton.enabled = false
                cell.nextButton.enabled = false
            }
            else {
                cell.backButton.enabled = true
                cell.playButton.enabled = true
                cell.nextButton.enabled = true
                
                cell.playButton.addTarget(self, action: "playPause:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.nextButton.addTarget(self, action: "fastForward:", forControlEvents: UIControlEvents.TouchUpInside)
                
                let currentIndex = self.player?.currentTrackIndex ?? Int32(0)
                let currentSong = playlist?.songs[Int(currentIndex)]
                cell.songLabel.text = currentSong?.name
                cell.artistLabel.text = currentSong?.artist
                
//                let auth = SPTAuth.defaultInstance()
                
//                var currentSong = playlist!.songs[indexPath.row]
//                SPTTrack.trackWithURI(self.player?.currentTrackURI, session: auth.session, callback: { (error : NSError?, object : AnyObject?) -> Void in
//                    
//                    let track = object as SPTTrack
//                    
//                    cell.songLabel.text = track.name
//                    cell.artistLabel.text = track.artists[0].name
//                    
//                    
//                })

                
            }
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("playlistSongCell", forIndexPath: indexPath) as UITableViewCell

            // Configure the cell...
            var currentSong = playlist!.songs[indexPath.row]
            cell.textLabel?.text = currentSong.name
            
            return cell
        }
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.handleNewSession()
    }
    
    func updatePlayer() {
        
        if (self.player?.currentTrackURI == nil) {
            
        }
        
        return
    }
    
    func handleNewSession() {
        let auth = SPTAuth.defaultInstance()
        
        if (self.player == nil) {
            self.player = SPTAudioStreamingController(clientId: auth.clientID)
            self.player!.playbackDelegate = self;
            self.player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
        }
        
        self.player?.loginWithSession(auth.session, callback: { (error : NSError?) -> () in
            if (error != nil) {
                NSLog("*** Enabaling playback got error: \(error)")
                return
            }
            
            self.updatePlayer()

            
//            self.player?.playURIs(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), fromIndex: 0, callback: nil)

            
//            SPTRequest.requestItemAtURI(self.player?.currentTrackURI, withSession: auth.session, callback: { (error : NSError!, albumObject : AnyObject!) -> Void in
//                if (error != nil) {
//                    NSLog("Album Lookup got error \(error)")
//                    return
//                }
//                let track = albumObject as SPTTrack
            
            self.player?.playURIs(self.playlist?.getURIs(), fromIndex: 0, callback: nil)
//                self.player?.playURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), fromIndex: 0, callback: nil)
//                self.player?.playTrackProvider(track, callback: nil)
                
            })
    }
    
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        let alertView = UIAlertView(title: "Messsage from Spotify", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alertView.show()
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didFailToPlayTrack trackUri: NSURL!) {
        NSLog("Failed to play track: \(trackUri)")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
        NSLog("track changed to index: \(self.player?.currentTrackIndex)")
        NSLog("Current track length: \(self.player?.trackListSize)")
        NSLog("Current queue length: \(self.player?.queueSize)")
        self.updatePlayer()
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        NSLog("Is playing = \(isPlaying)")
    }

    // Tableview Functions to support a custom height table cell (for the player)
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 100;
        }
        else {
            return 44;
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 100;
        }
        else {
            return 44;
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
