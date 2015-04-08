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
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistSongCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var currentSong = playlist!.songs[indexPath.row]
        cell.textLabel?.text = currentSong.name

        return cell
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.handleNewSession()
    }
    
    func updateUI() {
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
            
            self.updateUI()
            
//            self.player?.playURIs(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), fromIndex: 0, callback: nil)

            
            SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), withSession: auth.session, callback: { (error : NSError!, albumObject : AnyObject!) -> Void in
                if (error != nil) {
                    NSLog("Album Lookup got error \(error)")
                    return
                }
                let album = albumObject as SPTAlbum
                
//                self.player?.shitonmydick()
//                self.player?.playURIs(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), fromIndex: 0, callback: nil)
                self.player?.playTrackProvider(album, callback: nil)
                
            })
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
        NSLog("track changed!")
        self.updateUI()
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        NSLog("Is playing = \(isPlaying)")
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
