//
//  SearchViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/11/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var crowd : Crowd?
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchForSongByString(sender: AnyObject) {
        let searchString = searchField.text
        if searchString.isEmpty {
            return
        }
        
        SPTRequest.performSearchWithQuery(searchString, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: nil, callback: {(error: NSError!, result:AnyObject!) -> Void in
            
            if error != nil {
                println("error performing query")
                return
            }
            let trackListPage = result as SPTListPage
            let partialTrack = trackListPage.items.first as SPTPartialTrack
            // using first result for now.
            // will be able to use items.count to get the whole list...
            
            var newSong = Song()
            newSong.name = partialTrack.name
            newSong.spotifyURI = partialTrack.playableUri
            newSong.upvotes = 1
            self.crowd?.pending.addSong(newSong)
            println("Adding a new song")
            self.searchField.text = ""
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as CrowdTabViewController
        crowd = tbvc.myCrowd
        // Do any additional setup after loading the view.
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

}