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
        
        self.handleNewSession()
        
        
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
        
        
//        let currentTrackIndex = self.player?.queueSize ?? Int32(playlist!.songs.count)
//        let queueSize = playlist!.songs.count - crowd!.currentTrackIndex
////        NSLog("table size: \(queueSize)")
//        NSLog("queue size: \(player?.queueSize)")
//        
//        // The number of cells in the table view is the number of songs in the queue + 1 (for the song currently playing)
//        return Int(currentTrackIndex) + 1
    }

    func playPause(sender : UIButton!) {
        let bool = self.player?.isPlaying ?? true
        self.player?.setIsPlaying(!bool, callback: nil)
        NSLog("Pressed Play/Pause")
    }
    
    func fastForward(sender : UIButton!) {
        NSLog("Next song")
        self.player?.skipNext(nil)
        self.crowd?.currentTrackIndex++
        NSLog("Crowd Index: \(self.crowd?.currentTrackIndex)")
        NSLog("Now playing index: \(self.player?.currentTrackIndex)")
        self.updatePlayer()
    }
    
    func rewind(sender : UIButton!) {
        self.player?.skipPrevious(nil)
        NSLog("Rewinded to index: \(self.player?.currentTrackIndex)")
        self.updatePlayer()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Makes the first player cell
        if (indexPath.row == 0) {
            // custom cell
            let cell = tableView.dequeueReusableCellWithIdentifier("playerCell", forIndexPath: indexPath) as PlayerCell
            
            // If there are no songs playing anymore, disenable play buttons
            if self.player?.trackListSize == 0 {
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
                cell.backButton.addTarget(self, action: "rewind", forControlEvents: UIControlEvents.TouchUpInside)
                
                let currentIndex = self.player?.currentTrackIndex ?? Int32(0)
                let currentSong = playlist?.songs[Int(currentIndex)]
                cell.songLabel.text = currentSong?.name
                cell.artistLabel.text = currentSong?.artist

            }
            
            return cell
        }
        // Fills all the cells with the playlist
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("playlistSongCell", forIndexPath: indexPath) as UITableViewCell

            // Configure the cell...
            let currentSongIndex = self.player?.currentTrackIndex ?? -1
            
            var currentSong = playlist!.songs[indexPath.row]
            // Index is based on what song we are currently playing. Only shows songs that come after current song.
//            var currentSong = playlist!.songs[indexPath.row + Int(currentSongIndex)]
            cell.textLabel?.text = currentSong.name
            
            return cell
        }
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updatePlayer()
    }
    
    // Updates the tableView data which is populated with items that are in the player's queue
    func updatePlayer() {
        self.tableView.reloadData()
        
        return
    }
    
    // Initialzies the Player with you first load the table view
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

            // Adds the songs that are currently in the playlist - only works with static playlists
//            self.player?.queueURIs(self.playlist?.getURIs(), clearQueue: true, callback: nil)
            
            // Adds only the first song
            self.player?.queueURI(self.playlist?.songs[0].spotifyURI, clearQueue: true, callback: nil)
            
            })
    }
    
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        let alertView = UIAlertView(title: "Messsage from Spotify", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alertView.show()
    }
    
    // Receives event everytime a song stops playing
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        NSLog("Song \(self.player?.currentTrackIndex) stopped playing")
        if self.player?.currentTrackIndex != nil {
//            let index = self.player?.currentTrackIndex
            let index = self.crowd?.currentTrackIndex ?? 0
            self.player?.queueURI(playlist?.songs[index].spotifyURI, clearQueue: false, callback: nil)
        }
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
