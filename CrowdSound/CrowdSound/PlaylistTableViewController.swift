//
//  PlaylistTableViewController.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/16/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    // UI Elements
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playerView: UIView!
    
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var reverseButton: UIButton!
    

    var crowd : Crowd?
    var playlist : Playlist?
    
    var playlistEnded = false
    
    var player : SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Crowd from TabViewController
        let tbvc = self.tabBarController as CrowdTabViewController
        self.crowd = tbvc.myCrowd?
        playlist = crowd!.playlist
        
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        // @TODO: add if user or host flow
        
        // Initializes and logs-in to the SPTAudioStreamingController
        self.handleNewSession()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Player Control Methods
    
    @IBAction func playPause(sender: AnyObject) {
        NSLog("User pressed play/pause button")
        self.player?.setIsPlaying(!self.player!.isPlaying, callback: nil)
    }
    
    @IBAction func fastForward(sender: AnyObject) {
        
        self.player?.skipNext({ (error: NSError!) -> Void in
            if error != nil {
                NSLog("Error Skipping Song")
            }
        })
    }
    
    // TODO: Rewind Action: Need to figure out how to handle rewinding if it will be possible.
    @IBAction func rewind(sender: AnyObject) {
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return playlist!.count()// - (1 + (self.crowd?.currentTrackIndex ?? 0))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistSongCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let songIndex = indexPath.row //+ (1 + (self.crowd?.currentTrackIndex ?? 0))
        let song = playlist!.songs[songIndex]
        cell.textLabel?.text = song.name
        
        
        return cell
    }
    
    func updateUI() {
        
        self.tableView.reloadData()
        
        NSLog("Crowd, Player index: \(self.crowd?.currentTrackIndex), \(self.player?.currentTrackIndex)")
        NSLog("Current Track List: \(self.player?.trackListSize)")
        
        if self.playlistEnded {
            
            // TODO: Need to check if what happens when player is nil
            if self.crowd?.playlist.count() > Int(self.player!.trackListSize) {
                NSLog("updateUI(): replace URIs")
                self.player?.replaceURIs(self.crowd?.playlist.getURIs(), withCurrentTrack: Int32(self.crowd!.currentTrackIndex), callback: { (error:NSError!) -> Void in
                    if error != nil {
                        NSLog("Error replacing URIS \(error)")
                    }
                    
                    self.player?.setIsPlaying(true, callback: nil)
                })
                
                self.playlistEnded = false
            }
        }
        
        if self.crowd?.currentTrackIndex >= 0 && self.crowd?.currentTrackIndex < self.crowd?.playlist.count() {
            self.forwardButton.enabled = true
            self.playButton.enabled = true
            
            let currentSong = self.crowd?.playlist.songs[self.crowd!.currentTrackIndex]
            songLabel.text = currentSong?.name
            artistLabel.text = currentSong?.artist
        }
        else {
            // No more songs in the playlist: Disable Controls
            self.forwardButton.enabled = false
            self.playButton.enabled = false
            
            songLabel.text = ""
            artistLabel.text = ""
        }
        
    }
    
    // MARK: - SPTAudioController methods
    
    func handleNewSession() {
        // Called when the controller is first loaded
        
        let auth = SPTAuth.defaultInstance()
        
        // Create new player
        if (self.player == nil) {
            self.player = SPTAudioStreamingController(clientId: auth.clientID)
            self.player!.playbackDelegate = self;
            self.player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
        }
        
        // Log-in with the player
        self.player?.loginWithSession(auth.session, callback: { (error : NSError?) -> () in
            if (error != nil) {
                NSLog("*** Enabaling playback got error: \(error)")
                return
            }
            
            // Starts playing the first song
            self.crowd?.currentTrackIndex = 0
            if self.playlist?.count() > 0 {
                self.player?.playURIs(self.crowd?.playlist.getURIs(), fromIndex: 0, callback: nil)
            }
        })
        
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didFailToPlayTrack trackUri: NSURL!) {
        NSLog("Failed to play track: \(trackUri)")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
//        NSLog("Is playing = \(isPlaying)")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
        NSLog("didChangeToTrack(): track index \(self.crowd?.currentTrackIndex)")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {

        
        NSLog("didStopPlayingTrack(): Song \(self.crowd?.currentTrackIndex) Ended")
        self.crowd!.currentTrackIndex++
        
        // Turn player off when
        if self.crowd!.currentTrackIndex >= Int(self.player!.trackListSize) {
            NSLog("Playlist Ended")
            self.playlistEnded = true
            self.player?.setIsPlaying(false, callback: nil)
        }
        else {
            NSLog("replace URIs")
            self.player?.replaceURIs(self.crowd?.playlist.getURIs(), withCurrentTrack: Int32(self.crowd!.currentTrackIndex), callback: { (error:NSError!) -> Void in
            
                if error != nil {
                    NSLog("Error replacing URIS \(error)")

                }
            })
        }
        
        self.updateUI()
        
    }
    
    func audioStreamingDidSkipToNextTrack(audioStreaming: SPTAudioStreamingController!) {
//        NSLog("DidSkipToNextTrack() \(self.crowd?.currentTrackIndex)")
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
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
