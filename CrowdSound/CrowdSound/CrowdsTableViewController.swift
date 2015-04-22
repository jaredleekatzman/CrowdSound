//
//  CrowdsTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class CrowdsTableViewController: UITableViewController {

    @IBOutlet var configButton: UIBarButtonItem!
    
    var crowds = [Crowd]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionUpdateNotification:", name:
            "sessionUpdated", object: nil)

        var springFling = Crowd.defaultCrowd()
        springFling.name = "Spring Fling Playlist"
        crowds.append(springFling)
        
        var defaultCrowd = Crowd.defaultCrowd()
        defaultCrowd.name = "Jack's Naptime Playlist"
        crowds.append(defaultCrowd)
        
        var eliCrowd = Crowd.defaultCrowd()
        eliCrowd.host = "Eli"
        eliCrowd.name = "Eli's on a boat!"
        eliCrowd.password = "ELI - ELI - ELI"
        eliCrowd.isPrivate = true
        crowds.append(eliCrowd)
        
        var jaredCrowd = Crowd.defaultCrowd()
        jaredCrowd.name = "Jared's Fun Party"
        crowds.append(jaredCrowd)
        
        var timCrowd = Crowd.defaultCrowd()
        timCrowd.name = "Tim's Rockin' Party"
        crowds.append(timCrowd)
        
        var coding = Crowd.defaultCrowd()
        coding.name = "CPSC 365 Hangout"
        crowds.append(coding)
        
        var coding2 = Crowd.defaultCrowd()
        coding2.name = "Plug in to Code"
        crowds.append(coding2)
        
        var crowd1 = Crowd.defaultCrowd()
        crowd1.name = "Looking to boogy"
        crowds.append(crowd1)
        
        var crowd2 = Crowd.defaultCrowd()
        crowd2.name = "April 20th"
        crowds.append(crowd2)
        
        var crowd3 = Crowd.defaultCrowd()
        crowd3.name = "Goin' on a trip"
        crowds.append(crowd3)
        
        var crowd4 = Crowd.defaultCrowd()
        crowd4.name = "Skull n' Horns"
        crowds.append(crowd4)
        
        var crowd5 = Crowd.defaultCrowd()
        crowd5.name = "Noise Bans in New Haven"
        crowds.append(crowd5)
        
        var crowd6 = Crowd.defaultCrowd()
        crowd6.name = "Birthday Party Playlist"
        crowds.append(crowd6)
        
        crowds.append(defaultCrowd)
        crowds.append(eliCrowd)
        
        

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
        return crowds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("crowdCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var currentCrowd = crowds[indexPath.row]
        cell.textLabel?.text = currentCrowd.name

        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        if segue.identifier? == "showCrowd" {
            var secondScene = segue.destinationViewController as CrowdTabViewController
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let selectedCrowd = crowds[indexPath.row]
                secondScene.myCrowd = selectedCrowd
            }
        }
    }
}
