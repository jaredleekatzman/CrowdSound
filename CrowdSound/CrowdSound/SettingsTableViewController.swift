//
//  SettingsTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/18/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // crowd 
    var myCrowd = Crowd()
    
    // UI elements
    @IBOutlet weak var crowdNameLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UIView!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var passwordProtectedLabel: UILabel!
    @IBOutlet weak var showPasswordBtn: UIButton!

    // label variables
    let crowd_prefix = "Crowd Name: "
    let host_prefix = "Host Name: "
    let upvotes_prefix = "Upvotes: "
    let password_protected_prefix = "Password Protected: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the settings
        self.navigationItem.title = "Settings"
        loadSettingsIntoView()
    }
    
    // loads crowd settings into UI
    func loadSettingsIntoView() {
        
        // set crowd, host, and upvotes labels
        crowdNameLabel.text = crowd_prefix + myCrowd.name
        hostNameLabel.text = host_prefix + myCrowd.host
        upvotesLabel.text = upvotes_prefix + String(myCrowd.threshold)
        
        // add label for privacy setting
        if (myCrowd.isPrivate) {
            passwordProtectedLabel.text = password_protected_prefix + "Yes"
            showPasswordBtn.enabled = true
        } else {
            passwordProtectedLabel.text = password_protected_prefix + "No"
            showPasswordBtn.enabled = false
        }
    }
    
    // show crowd password when "show password" clicked in UI
    @IBAction func showPasswordPressed(sender: AnyObject) {
        
        // create alert
        var alertMsg = "Password: " + myCrowd.password
        var alert = UIAlertController(title: "Crowd Password", message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        // display alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
