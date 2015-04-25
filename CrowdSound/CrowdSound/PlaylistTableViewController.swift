//
//  PlaylistTableViewController.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/16/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate, updateTracklistObserver {
    
    // UI Elements
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playerView: UIView!
    
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var reverseButton: UIButton!
    
    @IBOutlet var albumView: UIImageView!

    var crowd : Crowd?
    var playlist : Playlist?
    
    var playlistEnded = false
    var isLastSong = false
    
    
    var player : SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Crowd from TabViewController
        let tbvc = self.tabBarController as CrowdTabViewController
        self.crowd = tbvc.myCrowd?
        playlist = crowd!.playlist
        
        // add delegates
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        // TODO: add if user or host flow
        
        // Initializes and logs-in to the SPTAudioStreamingController
        self.handleNewSession()
    }
    

    // PLAYER CONTROLS 
    
    // user pressed play/pause
    @IBAction func playPause(sender: AnyObject) {
        NSLog("in playPause")
        self.player?.setIsPlaying(!self.player!.isPlaying, callback: nil)
    }
    
    // user pressed fastForward
    @IBAction func fastForward(sender: AnyObject) {
        println("in fastforward")
        self.player?.skipNext({ (error: NSError!) -> Void in
            if error != nil {
                NSLog("Error Skipping Song: \(error)")
            }
        })
    }
    
    // user hit rewind
    @IBAction func rewind(sender: AnyObject) {
        println("in rewind")
        self.player?.skipPrevious({ (error: NSError!) -> Void in
            if error != nil {
                NSLog("Error Rewinding Song: \(error)")
            }
        })
    }
    
    
    // MARK: - SPTAudioController methods
    
    func handleNewSession() {
        println("in handle new session")
        // Called when the controller is first loaded
        
        let tbvc = self.tabBarController as CrowdTabViewController
        let auth = SPTAuth.defaultInstance()
        
        // Create new player
        if (tbvc.player == nil) {
            tbvc.player = SPTAudioStreamingController(clientId: auth.clientID)
            tbvc.player!.playbackDelegate = self;
            tbvc.player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
        }
        
        self.player = tbvc.player
        
        // Log-in with the player
        self.player?.loginWithSession(auth.session, callback: { (error : NSError?) -> () in
            if (error != nil) {
                NSLog("*** Enabaling playback got error: \(error)")
                return
            }
            
            // Starts playing the first song
            if self.playlist?.count() > 0 {
                var options = SPTPlayOptions() // default track index = 0, start from beginning 
                self.player?.playURIs(self.crowd?.playlist.getURIs(), withOptions: options, callback: nil)
            }
        })
        
    }
    
    // debugging: error in playing track
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didFailToPlayTrack trackUri: NSURL!) {
        println("in audioStreming-didFailToPlayTrack")
        NSLog("Failed to play track: \(trackUri)")
    }
    
    // for debugging: changed playback status
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        println("in audioStreaming-DidChangePlaybackStatus")
        NSLog("Is playing = \(isPlaying)")
    }
    
    // handle playing next song
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
        print("in audioStreaming-DidChangeToTrack")
        
        // last song was just played -- reset playlist
        if isLastSong {
            println("should reset playlist")
            self.player?.replaceURIs(self.crowd?.playlist.getURIs(), withCurrentTrack: Int32(0), callback: { (error:NSError!) -> Void in
                if (error != nil) {
                    NSLog("error replacing uris: \(error)")
                }
                
                // keep this here
                self.updatePlayerArt()
                self.player?.setIsPlaying(true, callback: nil)
                self.isLastSong = false
            })
        }
    }
    
    
    // handle song transition
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        println("in audioStreaming-didStopPlayingTrack")

        println("in audioStreaming-didStopPlayingTrack")
        var index = self.player?.currentTrackIndex
        var uris = self.crowd?.playlist.getURIs()
        var urisLength = uris?.count

        // if error in player
        if (index == nil) {
            return
        }
        
        println("length of new URIs = \(uris)")
        
        // playing last song
        if let urisLength = uris?.count {
            if Int(index!) >= urisLength - 1 {
                isLastSong = true
            }
        }
//
//        // replace URIs in player
//        self.player?.replaceURIs(uris, withCurrentTrack: Int32(index!), callback: { (error:NSError!) -> Void in
//            if (error != nil) {
//                NSLog("error replacing uris: \(error)")
//            }
//        })
        
        // TODO: alert users when playlist restarting?
        

        
        // self.updatePlayerTracklist()
        self.updatePlayerArt()
    }
    
    // declared in updateTracklistObserver
    //  when playlist grows, will call this function to update the player's queue.
    func updatePlayerTracklist() {
        println("==========================in updatePlayerTracklist==================================")
//        let playlistIndex = self.player?.currentTrackIndex
//        let nextSongIndex = Int(playlistIndex!) + 1
//        println("nextSongindex = \(nextSongIndex)")
        
        let uris = self.crowd?.playlist.getURIs()
        let playlistIndex = self.player?.currentTrackIndex
        
        self.player?.replaceURIs(uris, withCurrentTrack: Int32(playlistIndex!), callback: { (error: NSError!) -> Void in
            
            if error != nil {
                println("error replacing uris in updatePlayerTracklist: \(error)")
            }
        
        })
        
        
    
        self.tableView.reloadData()
        
        // if at last song
//        if (self.crowd?.playlist.count() == nextSongIndex + 1) {
//            isLastSong = true
//        }
//        else if (self.crowd?.playlist.count() > nextSongIndex) {
//            if isLastSong {
//                println("resetting last song")
//                isLastSong = false
//            }
//            
//            var uris = self.crowd?.playlist.getURIs()
//            var urisLength = uris?.count
////            var index = self.player?.currentTrackIndex
//
//            println("length of new URIs = \(uris)")
//            
//
//            // replace URIs in player
//            self.player?.replaceURIs(uris, withCurrentTrack: Int32(playlistIndex!), callback: { (error:NSError!) -> Void in
//                if (error != nil) {
//                    NSLog("error replacing uris: \(error)")
//                }
//            })
//            
//        }
//            var index = self.player?.currentTrackIndex
//        var uris = self.crowd?.playlist.getURIs()
//        var urisLength = uris?.count
        
//        // if error in player
//        if (index == nil) {
//            return
//        }
        
//        println("length of new URIs = \(uris)")
//        
//        // playing last song
//        if let urisLength = uris?.count {
//            if Int(index!) >= urisLength - 1 {
//                isLastSong = true
//            }
//        }
//        
//        // replace URIs in player
//        self.player?.replaceURIs(uris, withCurrentTrack: Int32(index!), callback: { (error:NSError!) -> Void in
//            if (error != nil) {
//                NSLog("error replacing uris: \(error)")
//            }
//        })
        

    }
    
    // skipped to next track
    func audioStreamingDidSkipToNextTrack(audioStreaming: SPTAudioStreamingController!) {
        println("in audioStreaming-didSkipToNextTrack")
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return number of sections
        return 1
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        self.updatePlayerArt()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        NSLog("Back pressed")
        if parent == nil {
            NSLog("Back 0")
        }
        if let bool = parent?.isEqual(self.parentViewController) {
            if !bool {
                NSLog("Back 1")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return playlist!.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // configure the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistSongCell", forIndexPath: indexPath) as UITableViewCell
        let song = playlist!.songs[indexPath.row]
        cell.textLabel?.text = song.name
        return cell
    }
    
    // TODO: when reload data, if size increases & isLastSong == true, set isLastSong = false

    func updatePlayerArt() {
        println("IN UPDATE-PLAYER-ART")
        
//        let playlistIndex = self.player?.currentTrackIndex
//        let oldSize = Int(playlistIndex!) + 1
//        println("oldPlaylistSize = \(oldSize)")
//        self.tableView.reloadData()
//        
//        if (isLastSong && self.crowd?.playlist.count() > oldSize) {
//            println("WE SHOULD FUCKING CHANGE THIS")
//            isLastSong = false
//        }
        
        // if after reloading data we are on the last song, and our new size > old size
        
//        self.tableView.reloadData()

        if (playlist!.count() > 0) {
            self.forwardButton.enabled = true
            self.playButton.enabled = true
            var index = self.player?.currentTrackIndex
            
            let currentSong = self.playlist!.songs[Int(index!)]
            songLabel.text = currentSong.name
            
            
            SPTTrack.trackWithURI(currentSong.spotifyURI, session: SPTAuth.defaultInstance().session, callback: { (error:NSError!, obj: AnyObject!) -> Void in
                if error != nil {
                    NSLog("no session")
                    return
                }
                else {
                    NSLog("Found track with URI")
                    let track = obj as SPTTrack
                    self.songLabel.text = track.name
                    self.artistLabel.text = track.artists[0].name
                    
                    let imageURL = track.album.largestCover.imageURL
                    if (imageURL == nil) {
                        NSLog("No Album Art")
                        self.albumView.image = nil;
                        return
                    }
                    
                    // Pop over to a background queue to load the image over the network.
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        var err : NSErrorPointer
                        var image : UIImage?
                        
                        let imageData = NSData(contentsOfURL: imageURL)
                        if (imageData != nil) {
                            image = UIImage(data: imageData!)
                        }
                        
                        // ... and back to the main queue to display the image
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.albumView.image = image
                            if (image == nil) {
                                NSLog("Couldn't load cover image")
                                return
                            }
                        })
                    })
                }
            })
        }
        else {
            // No songs in the playlist: Disable Controls
            self.forwardButton.enabled = false
            self.playButton.enabled = false
            
            songLabel.text = ""
            artistLabel.text = ""
            albumView.image = nil
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
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
