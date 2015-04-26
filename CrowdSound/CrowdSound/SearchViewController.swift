//
//  SearchViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/11/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    var crowd : Crowd?

    @IBOutlet weak var songTable: UITableView!
    var songSearchController = UISearchController()

    // Used by SearchController to filter search results
    var searchArray:[Song] = [Song](){
        didSet  {self.songTable.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get crowd
        let tbvc = self.tabBarController as CrowdTabViewController
        crowd = tbvc.myCrowd
        
        // Configure songTable
        self.songTable.delegate = self
        self.songTable.dataSource = self
        
        // Configure songSearchController
        self.definesPresentationContext = true
        self.songSearchController = ({
            // Two setups provided below:
            
            // Setup One: This setup present the results in the current view.
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            controller.delegate = self
            
            self.songTable.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.view.addSubview(self.songSearchController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableViewDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.songTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if (self.songSearchController.active)
        {
            cell.textLabel?.text = self.searchArray[indexPath.row].name
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.crowd?.pending.addSong(searchArray[indexPath.row])
        var alertMsg = "Added song " + searchArray[indexPath.row].name + " to pending songs"
        
        // Display alert if necessary
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchArray.removeAll(keepCapacity: false)
        let searchString = searchController.searchBar.text
        
        // Lookup songs using Spotify
        SPTRequest.performSearchWithQuery(searchString, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: nil, callback: {(error: NSError!, result:AnyObject!) -> Void in
            
            if error != nil && searchString != "" {
                println("error performing query")
                return
            }
            // Extract Search Results
            let trackListPage = result as SPTListPage
            let items = trackListPage.items
            var resultsArray = [Song]()
            
            if (items == nil) {
                return
            }
            // Creates a Song object for each search result
            for item in items {
                var newSong = Song()
                let partialTrack = item as SPTPartialTrack
                newSong.name = partialTrack.name
                newSong.spotifyURI = partialTrack.playableUri
                newSong.upvotes = 1
                resultsArray.append(newSong)

            }
            self.searchArray = resultsArray
        })
    }

}