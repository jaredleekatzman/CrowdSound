//
//  SearchViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/11/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    // table view for search results
    @IBOutlet weak var songTable: UITableView!
    var songSearchController = UISearchController()
    var crowd : Crowd?
    
    // define socket.io in class
//    let socket = SocketIOClient(socketURL: "localhost:8080")
//
//    func addHandlers() {
//        
//        //chat messages because why not:
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
//    }
//    
    // data source for songTable.
    //  reloads songTable whenever updated.
    var searchArray:[Song] = [Song](){
        didSet  {self.songTable.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get crowd
        let tbvc = self.tabBarController as CrowdTabViewController
        crowd = tbvc.myCrowd
        
        // Configure songTable
        self.songTable.delegate         = self
        self.songTable.dataSource       = self
        
        // UI Code: Set 'Bounce Area' background to be black
        let topView = UIView(frame: CGRectMake(0, -480, 500, 480))
        topView.backgroundColor = UIColor.blackColor()
        self.songTable.addSubview(topView)
        
        
        // Configure songSearchController
        self.songSearchController = ({

            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater                 = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation     = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            controller.delegate                             = self
            controller.searchBar.barStyle                   = UIBarStyle.Black
            controller.searchBar.tintColor                  = self.view.tintColor
            
            self.songTable.tableHeaderView                  = controller.searchBar
            self.definesPresentationContext = true
            return controller
        })()
        
        // WebSockets
//        self.addHandlers()
//        self.socket.connect()
    
    }

    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // table has as many rows as search results.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.songSearchController.active)
        {
            return self.searchArray.count
            
        } else
        {
            return 0
        }
    }
    
    // populate each row in songTable with name of song in corresponding element of searchResults
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.songTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if (self.songSearchController.active)
        {
            cell.textLabel?.text = self.searchArray[indexPath.row].name
            cell.detailTextLabel?.text = self.searchArray[indexPath.row].artist
        }
        cell.layoutSubviews()
        return cell
    }
    
    // send song object of selected row to the pending playlist.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // create new song object to add to pending.
        let song            = searchArray[indexPath.row]
        var newSong         = Song(name: song.name, artist: song.artist, uri: song.spotifyURI, albumArt: song.spotifyAlbumArtURL)
        
        // add song.
        self.crowd?.pending.addSong(newSong)
        
        // send song to database
        if let dict = JSONSerializer.serializeNewSongToPending(crowd!.uid, song: newSong) {
            //if let dict = JSONSerializer.serializeUpvote(crowdUID, songID: songUID) {
            println("adding song to pending! which is \(dict)")
//            self.socket.emit("newPending", dict)
            Socket.currentSocket.socketIO.emit("newPending", dict)
        }
        
        
        var alertMsg = "Added song " + newSong.name + " to pending songs"
        
        // Display alert if necessary
        // alert user song has been added.
        var alert = UIAlertController(title: "Added song!", message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        // Reset SongSearchController
        self.songSearchController.active = false
        self.songSearchController.searchBar.text = ""
    }
    

    // MARK: - SearchControllerDelegate Methods
    
    // TODO: if search not 'cancelled,' search bar is still open on other views (segue)
    // TODO: when search is 'cancelled,' there is one song in the array when there should be none.
    // TODO: crashes after typing a while in the search...?
    // TODO: add artist to search results. 
    // TODO: cancel the search in the prepare for segue (otherwise black page error)
    // TODO: if search not 'cancelled,' search bar is still open on other views
    
    // search for spotify songs with searchbar text as query string; populate searchArray
    //  and songTable accordingly.
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchArray.removeAll(keepCapacity: false)
        let searchString = searchController.searchBar.text
        
        // Send searchbar text to spotify.
        SPTRequest.performSearchWithQuery(searchString, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: nil, callback: {(error: NSError!, result:AnyObject!) -> Void in
            
            if error != nil {
                println("error performing query")
                return
            }

            // parse spotify search results into items.
            let trackListPage   = result as SPTListPage
            let items           = trackListPage.items
            var resultsArray    = [Song]()
            if (items == nil) {
                return
            }
            
            // create a new song for each result and add to resultsArray.
            for item in items {
                var newSong = Song()
                let partialTrack    = item as SPTPartialTrack
                newSong.name        = partialTrack.name
                newSong.spotifyURI  = partialTrack.playableUri
                newSong.upvotes     = 1
                
                
                SPTTrack.trackWithURI(newSong.spotifyURI, session: nil, callback: { (error:NSError!, obj: AnyObject!) -> Void in
                    if (error != nil) {
                        println("error getting track: \(error)")
                        self.searchArray.append(newSong)
                    }
                    let track = obj as SPTTrack
                    if let artist = track.artists[0].name {
                        newSong.artist = artist
                        println(newSong.artist)
                    }
                    if let imageURL = track.album.largestCover?.imageURL {
                        newSong.spotifyAlbumArtURL = imageURL
                    }
                    
                    self.searchArray.append(newSong)
                })
                
                
            }
            
            // update search array, which updates songTable.
//            self.searchArray = resultsArray
        })
    }

}