//
//  ConfigTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/10/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class ConfigTableViewController: UITableViewController, SPTAuthViewDelegate {
    
    @IBOutlet weak var crowdNameText: UITextField!
    @IBOutlet weak var hostNameText: UITextField!
    @IBOutlet weak var upvotesSlider: UISlider!
    @IBOutlet weak var finalizeCrowdBtn: UIButton!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordProtectedSwitch: UISwitch!
    @IBOutlet weak var spotifyStatusLabel: UILabel!
    @IBOutlet weak var spotifyLoginBtn: UIButton!

    var authViewController : SPTAuthViewController?
    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionUpdateNotification:", name: "sessionUpdated", object: nil)
        if isLoggedIntoSpotify() {
            spotifyStatusLabel.text = "Spotify Status: Logged In"
            spotifyLoginBtn.setTitle("Log Out", forState: UIControlState.Normal)
        }
    }
    
    func sessionUpdatedNotification(notification : NSNotification) {
        if self.navigationController?.topViewController == self {
            let auth = SPTAuth.defaultInstance()
            if (auth.session != nil && auth.session.isValid()) {
                
                // TODO: change so button is now logout or somethign
            }
        }
    }
    
    func isLoggedIntoSpotify() -> Bool {
        let auth = SPTAuth.defaultInstance()
        if auth.session != nil && auth.session.isValid() {
            return true
        }
        return false
    }
    
    @IBAction func spotifyBtnPressed(sender: AnyObject) {
        let auth = SPTAuth.defaultInstance()
        if isLoggedIntoSpotify() {
            auth.session = nil
            spotifyStatusLabel.text = "Spotify Status: Logged Out"
            spotifyLoginBtn.setTitle("Log In", forState: UIControlState.Normal)
        } else {
            self.openLoginPage()
        }
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        NSLog("*** Failed to log in \(error)")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        // Login worked!
        spotifyStatusLabel.text = "Spotify Status: Logged In"
        spotifyLoginBtn.setTitle("Log Out", forState: UIControlState.Normal)
        
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
    
    func renewTokenAndShowButton() {
        let auth = SPTAuth.defaultInstance()
        
        auth.renewSession(auth.session, callback: { (error : NSError?, session : SPTSession?) -> () in
            auth.session = session
            
            if (error != nil) {
                NSLog("*** Error renewing session \(error)")
                return
            }
        })
    }
    
    
    override func viewWillAppear(animated: Bool) {
        var auth = SPTAuth.defaultInstance()
        
        // Check if we have a token at all
        if auth.session == nil {
            NSLog("Have a token")
            return
        }
        
        // Check if it's still valid
        if auth.session.isValid() {
            
            NSLog("session is valid")
            // Change buttons
            return
        }
        
        if auth.hasTokenRefreshService {
            NSLog("renew Token!")
            
            self.renewTokenAndShowButton()
            return
        }
        
    }
    
    
    @IBAction func upvoteSliderMoved(sender: AnyObject) {
        var sliderVal = Int(upvotesSlider.value)
        upvotesSlider.value = Float(sliderVal)
        upvotesLabel.text = "Upvotes: " + sliderVal.description
    }
    
    @IBAction func finalzeCrowdPushed(sender: AnyObject) {
        var alertMsg = ""
        
        // basic required fields
        if (crowdNameText.text.isEmpty) {
            alertMsg += "Crowd must have a name. "
        }
        if (hostNameText.text.isEmpty) {
            alertMsg += "Host must have a name. "
        }
        if (!isLoggedIntoSpotify()) {
            alertMsg += "You must log into spotify. "
        }
        
        // requirements if password protected
        if (passwordProtectedSwitch.on) {
            if (passwordText.text.isEmpty) {
                alertMsg += "Must have password if password protection is on. "
            } else if (passwordText.text != confirmPasswordText) {
                alertMsg += "Passwords do not match. "
            }
        }
        
        // display alert if necessary
        if (!alertMsg.isEmpty) {
            var alert = UIAlertController(title: "Crowd Creation Error", message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // create crowd before leaving
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "finalizeCrowd" {
            var secondScene = segue.destinationViewController as CrowdTabViewController
            secondScene.myCrowd = createCrowd()
            
            // TODO: add crowd to database
            // TODO: figure out how not to go all the way back to crowd preferences!!
        }
    }
    
    // create the crowd
    func createCrowd() -> Crowd {
        var crowd = Crowd()
        crowd.name = crowdNameText.text
        crowd.host = hostNameText.text
        crowd.threshold = Int(upvotesSlider.value)
        crowd.isPrivate = passwordProtectedSwitch.on
        crowd.password = passwordText.text
        return crowd
    }
}