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
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    

    // Crowd Data
    var crowd : Crowd?
    
    var playlistEnded = false
    
    // class variables
    var player : SPTAudioStreamingController? // for spotify streaming

    
    // check to see if currently playing last song
    var isLastSong = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Crowd from TabViewController
        let tbvc = self.tabBarController as CrowdTabViewController
        self.crowd = tbvc.myCrowd?
        
        // add delegates
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        // TODO: add if user or host flow
        // set the delegate
        self.crowd?.playlist.playlistDelegate = self
        
        // Initializes and logs-in to the SPTAudioStreamingController
        self.handleNewSession()
        
        // Handle Progress Bars
        
    }
    

    // PLAYER CONTROLS 
    
    // user pressed play/pause
    @IBAction func playPause(sender: AnyObject) {
        self.player?.setIsPlaying(!self.player!.isPlaying, callback: nil)
    }
    
    // user pressed fastForward
    @IBAction func fastForward(sender: AnyObject) {
        self.player?.skipNext({ (error: NSError!) -> Void in
            if error != nil {
                NSLog("Error Skipping Song: \(error)")
            }
        })
    }
    
    // user hit rewind
    @IBAction func rewind(sender: AnyObject) {
        if isLastSong {
            isLastSong = false
        }
        self.player?.skipPrevious({ (error: NSError!) -> Void in
            if error != nil {
                NSLog("Error Rewinding Song: \(error)")
            }
        })
    }
    
    
    // MARK: - SPTAudioController methods
    
    // spotify default: handle new session
    func handleNewSession() {
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
            if self.crowd?.playlist.count() > 0 {
                var options = SPTPlayOptions() // default track index = 0, start from beginning 
                self.player?.playURIs(self.crowd?.playlist.getURIs(), withOptions: options, callback: nil)
                
                // Start Progress Bar
                self.progressView.setProgress(0, animated: true)
            }
        })
        
    }
    
    // debugging: error in playing track
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didFailToPlayTrack trackUri: NSURL!) {
        NSLog("Failed to play track: \(trackUri)")
    }
    
    // for debugging: changed playback status
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        NSLog("Is playing = \(isPlaying)")
        if self.player!.isPlaying {
            playButton.setImage(UIImage(named: "pauseButton"), forState: UIControlState.Normal)
        } else {
            playButton.setImage(UIImage(named: "playButton"), forState: UIControlState.Normal)
        }
    }
    
    // handle playing next song
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
        
        // last song was just played -- reset playlist
        if isLastSong {
            println("should reset playlist")
            self.player?.replaceURIs(self.crowd?.playlist.getURIs(), withCurrentTrack: Int32(0), callback: { (error:NSError!) -> Void in
                if (error != nil) {
                    NSLog("error replacing uris: \(error)")
                }
                
                // update information
                self.updatePlayerArt()
                self.player?.setIsPlaying(true, callback: nil)
                self.isLastSong = false
            })
        }
        
        // Update Progress Bar
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            while (self.player?.currentPlaybackPosition.distanceTo(self.player!.currentTrackDuration) != 0) {
                
                let num = Float(self.player?.currentPlaybackPosition ?? 0)
                let denom = Float(self.player?.currentTrackDuration ?? 1)
                let frac = num / denom
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressView.setProgress(frac, animated: true)
                    return
                })
               
            }
            
        })
    }
    
    // handle song transition
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        var index = self.player?.currentTrackIndex
        var uris = self.crowd?.playlist.getURIs()
        var urisLength = uris?.count

        // if error in player
        if (index == nil) {
            return
        }
        // playing last song
        // if playing last song, set variable
        if let urisLength = uris?.count {
            if Int(index!) >= urisLength - 1 {
                isLastSong = true
            }
        }

        // update UI art
        self.updatePlayerArt()
    }
    
    // when new song in playlist, this delegate fetches new data
    func updatePlayerTracklist() {
        
        // gets URI informaiton from playlist and current position
        let uris = self.crowd?.playlist.getURIs()
        let playlistIndex = self.player?.currentTrackIndex
        
        // if was playing the last song, and added a song, set isLastSong to flase.
        if Int(playlistIndex!) + 1 < uris?.count {
            isLastSong = false
        }

        // replace URIs of player with new URIs
        self.player?.replaceURIs(uris, withCurrentTrack: Int32(playlistIndex!),
            callback: { (error: NSError!) -> Void in
            
            if error != nil {
                println("error replacing uris in updatePlayerTracklist: \(error)")
            }
        
        })
        // reload table UI
        self.tableView.reloadData()

    }
    
    // skipped to next track
    func audioStreamingDidSkipToNextTrack(audioStreaming: SPTAudioStreamingController!) {
        NSLog("skipping to next track")
    }
    
    // enable player buttons
    func enableButtons() {
        self.forwardButton.enabled = true
        self.playButton.enabled = true
        self.reverseButton.enabled = true
    }
    
    // disable player buttons
    func disableButtons() {
        self.forwardButton.enabled = false
        self.playButton.enabled = false
        self.reverseButton.enabled = false
    }

    
    // Used for debugging
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            NSLog("Back 0")
        }
        if let bool = parent?.isEqual(self.parentViewController) {
            if !bool {
                NSLog("Back 1")
            }
        }
    }
    
    // MARK: - TableViewDataSourceDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.crowd!.playlist.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // configure the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistSongCell", forIndexPath: indexPath) as UITableViewCell
        let song = crowd!.playlist.songs[indexPath.row]
        cell.textLabel?.text = song.name
        
        if (indexPath.row == Int(self.player!.currentTrackIndex)) {
//            cell.textLabel?.textColor = UIColor(red: 254.0, green: 230.0, blue: 88.0, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.yellowColor()
            
        } else {
            cell.textLabel?.textColor = UIColor.whiteColor()
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("Got here")
        let uris = self.crowd?.playlist.getURIs()
        
        // replace URIs of player with new URIs
        self.player?.playURIsFromIndex(Int32(indexPath.row), callback: { (error: NSError!) -> Void in
            if error != nil {
                NSLog("error playing track \(indexPath.row)")
            }
        })
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // reload table UI
        self.updatePlayerArt()
        println("Current index \(self.player?.currentTrackIndex)")
        
    }
    
    // TODO: when reload data, if size increases & isLastSong == true, set isLastSong = false
    
    // Updates PlayerAlbumArt
    func updatePlayerArt() {
        if (self.crowd!.playlist.count() > 0) {
            self.forwardButton.enabled = true
            self.playButton.enabled = true
            var index = self.player?.currentTrackIndex
            
            let currentSong = self.crowd!.playlist.songs[Int(index!)]
            songLabel.text = currentSong.name
            
            // Download Album Art
            SPTTrack.trackWithURI(currentSong.spotifyURI, session: SPTAuth.defaultInstance().session, callback: { (error:NSError!, obj: AnyObject!) -> Void in
                if error != nil {
                    NSLog("No session")
                    return
                }
                else {
                    // find song title and artists name
                    NSLog("Found track with URI")
                    let track = obj as SPTTrack
                    self.songLabel.text = track.name
                    self.artistLabel.text = track.artists[0].name
      
                    // get the image URL
                    let imageURL = track.album.largestCover.imageURL
                    if (imageURL == nil) {
                        NSLog("No Album Art")
                        self.albumView.image = nil
                        self.backgroundImage.image = nil
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
                                NSLog("Cannot load cover image")
                                return
                            }
                        })
                        
                        // Blur Image for Background
                        // Test: if image is nil
                        let blurred = self.applyBlurOnImage(image!, withRadius: 20.0)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.backgroundImage.image = blurred
//                            NSLog("Blurred Background")
                        })
                        
                    })
                }
            })
        }
        else {
            // No songs in the playlist: Disable Controls
            disableButtons()
            
            // reset the UI
            songLabel.text = ""
            artistLabel.text = ""
            albumView.image = nil
        }
        
        // Scroll the Table View to the position of the current playing song
        let ind = Int(self.player?.currentTrackIndex ?? 0)
        let path = NSIndexPath(forItem: ind, inSection: 0)
        if ind > 0 {
            self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }

        self.tableView.reloadData()
    }
    
    // Translated from Spotify Demo Project: Simple Audio Playback
    func applyBlurOnImage(imageToBlur : UIImage, withRadius blurRadius: CGFloat) -> UIImage {
        
        let originalImage = CIImage(CGImage: imageToBlur.CGImage)
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputImageKey : originalImage, "inputRadius" : blurRadius])
        
        let outputImage = filter.outputImage
        let context = CIContext(options: nil)
        
        let outImage = context.createCGImage(outputImage, fromRect: outputImage.extent())
        let ret = UIImage(CGImage: outImage)
        
        return ret!
        
    }
    
    // MARK: - Table view data source - Defaulted
    
    // when view appears, reload basic data.
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        self.updatePlayerArt()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return number of sections
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}