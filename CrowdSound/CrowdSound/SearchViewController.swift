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
    
    // data source for songTable.
    //  reloads songTable whenever updated.
    var searchArray:[Song] = [Song](){
        didSet  {self.songTable.reloadData()}
    }
    
    var crowd : Crowd?
    var songSearchController = UISearchController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tbvc = self.tabBarController as CrowdTabViewController
        crowd = tbvc.myCrowd
        
        // Configure songTable
        self.songTable.delegate         = self
        self.songTable.dataSource       = self
        self.definesPresentationContext = true
        
        // Configure songSearchController
        self.songSearchController = ({

            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater                 = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation     = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            controller.delegate                             = self
            self.songTable.tableHeaderView                  = controller.searchBar
            
            return controller
        })()
        
    }

    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // reset songTable to original state.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.songTable.reloadData()
    }

    // MARK: - Navigation
    override func viewWillAppear(animated: Bool) {

        self.songSearchController.active         = false
        self.songSearchController.searchBar.text = ""
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.songSearchController.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        println("1")
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        println("2")
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        println("3")
    }
    
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
            return cell
        }
            
        else
        {
            return cell
        }
    }
    
    // send song object of selected row to the pending playlist.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // create new song object to add to pending.
        var newSong         = Song()
        newSong.name        = searchArray[indexPath.row].name
        newSong.spotifyURI  = searchArray[indexPath.row].spotifyURI
        newSong.upvotes     = 1
        
        // add song.
        self.crowd?.pending.addSong(newSong)
        var alertMsg = "Added song " + newSong.name + " to pending songs"
        
        // alert user song has been added.
        var alert = UIAlertController(title: "Added song!", message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // TODO: if search not 'cancelled,' search bar is still open on other views
    
    // search for spotify songs with searchbar text as query string; populate searchArray
    //  and songTable accordingly.
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchArray.removeAll(keepCapacity: false)
        let searchString = searchController.searchBar.text
        
        // send searchbar text to spotify.
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
                resultsArray.append(newSong)

            }
            
            // update search array, which updates songTable.
            self.searchArray = resultsArray
        })
    }

}