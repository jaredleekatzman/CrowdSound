//
//  CrowdsTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class CrowdsTableViewController: UITableViewController, SPTAuthViewDelegate {

    @IBOutlet weak var barButton: UIBarButtonItem!
    
    var authViewController : SPTAuthViewController?
    var crowds = [Crowd]() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionUpdateNotification:", name: "sessionUpdated", object: nil)

        var defaultCrowd = Crowd.defaultCrowd()
        var eliCrowd = Crowd.defaultCrowd()
        eliCrowd.host = "Eli"
        eliCrowd.name = "Eli's on a boat!"
        
        crowds.append(defaultCrowd)
        crowds.append(eliCrowd)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func sessionUpdatedNotification(notification : NSNotification) {
        if self.navigationController?.topViewController == self {
            let auth = SPTAuth.defaultInstance()
            if (auth.session != nil && auth.session.isValid()) {
                self.showConfigButton()
            }
        }
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
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        NSLog("*** Failed to log in \(error)")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        self.showConfigButton()
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        // Login Cancelled
    }
    
    func openLoginPage() {
        self.authViewController = SPTAuthViewController.authenticationViewController()
        self.authViewController?.delegate = self;
        self.authViewController?.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.authViewController?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.definesPresentationContext = true;
        
        self.presentViewController(self.authViewController!, animated: false, completion: nil)
    }
    
    
    func showConfigButton() {
        // Need to switch toolbar buttons 
        return
    }
    
    func renewTokenAndShowButton() {
        let auth = SPTAuth.defaultInstance()
        
        auth.renewSession(auth.session, callback: { (error : NSError?, session : SPTSession?) -> () in
            auth.session = session
            
            if (error != nil) {
                NSLog("*** Error renewing session \(error)")
                return
            }
            self.showConfigButton()
        })
    }
    
    
    override func viewWillAppear(animated: Bool) {
        var auth = SPTAuth.defaultInstance()
        
        // Check if we have a token at all
        if auth.session == nil {
            return
        }
        
        // Check if it's still valid
        if auth.session.isValid() {
            
            // Change buttons
            return
        }
        
        if auth.hasTokenRefreshService {
            self.renewTokenAndShowButton()
            return
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
