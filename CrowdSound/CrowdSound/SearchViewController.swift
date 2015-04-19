//
//  SearchViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/11/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    var crowd : Crowd?
    
    
    @IBOutlet weak var songTable: UITableView!
    
    var searchArray:[Song] = [Song](){
        didSet  {self.songTable.reloadData()}
    }
    var songSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as CrowdTabViewController
        crowd = tbvc.myCrowd
        // Do any additional setup after loading the view.
        
        
        // Configure countryTable
        self.songTable.delegate = self
        self.songTable.dataSource = self
        
        
        // Configure countrySearchController
        self.songSearchController = ({
            // Two setups provided below:
            
            // Setup One: This setup present the results in the current view.
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            self.songTable.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.songTable.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
            return cell
        }
            
        else
        {
            // TODO: worried about an error in this branch.
            //cell.textLabel?.text! = self.countryArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.crowd?.pending.addSong(searchArray[indexPath.row])
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchArray.removeAll(keepCapacity: false)
        
        // let searchPredicate = NSPredicate(format:ELF CONTAINS[c] %@", searchController.searchBar.text)
        // let array = (self.countryArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        // self.searchArray = array as! [String]
        
        
        let searchString = searchController.searchBar.text
        
        SPTRequest.performSearchWithQuery(searchString, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: nil, callback: {(error: NSError!, result:AnyObject!) -> Void in
            
            if error != nil {
                println("error performing query")
                return
            }
            let trackListPage = result as SPTListPage
            //let partialTrack = trackListPage.items.first as SPTPartialTrack
            // using first result for now.
            // will be able to use items.count to get the whole list...
            
            let items = trackListPage.items

            var resultsArray = [Song]()
            
            for item in items {
                var newSong = Song()
                let partialTrack = item as SPTPartialTrack
                newSong.name = partialTrack.name
                println(newSong.name)
                newSong.spotifyURI = partialTrack.playableUri
                newSong.upvotes = 1
                // TODO: add the artist name to the song!!
                resultsArray.append(newSong)
//                self.searchArray.append(newSong)
            }
            println("Results Array: \(resultsArray.map { a in a.name })")
            
            self.searchArray = resultsArray
            println("Search Array: \(self.searchArray.map { a in a.name })")

//            self.crowd?.pending.addSong(newSong)
//            println("Adding a new song")
//            self.searchField.text = ""
        })
    }

}