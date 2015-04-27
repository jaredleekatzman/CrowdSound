//
//  ConfigTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/10/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class ConfigTableViewController: UITableViewController, SPTAuthViewDelegate {
    
    // authView for spotify login.
    var authViewController : SPTAuthViewController?
    
    // UI elements
    @IBOutlet weak var crowdNameText: UITextField!
    @IBOutlet weak var hostNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var finalizeCrowdBtn: UIButton!
    @IBOutlet weak var spotifyLoginBtn: UIButton!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var spotifyStatusLabel: UILabel!
    @IBOutlet weak var passwordProtectedSwitch: UISwitch!
    @IBOutlet weak var upvotesSlider: UISlider!
    
    // string prefixes 
    let upvotes_prefix = "Upvotes: "
    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "sessionUpdateNotification:", name: "sessionUpdated", object: nil)
        updateLoginButton()
    }
    
    // USER INTERFACE FUNCTIONS
    
    // get value from upvote slider
    @IBAction func upvoteSliderMoved(sender: AnyObject) {
        var sliderVal = Int(upvotesSlider.value)
        upvotesSlider.value = Float(sliderVal)
        upvotesLabel.text = upvotes_prefix + sliderVal.description
    }
    
    // user pushes "Finalize Crowd" button
    @IBAction func finalzeCrowdPushed(sender: AnyObject) {
        
        // create alertMsg for missing fields
        var alertMsg = createCrowdAlertMsg()
        
        // display alert if necessary -- if not, automatically prepare for segue
        if (!alertMsg.isEmpty) {
            var alert = UIAlertController(title: "Crowd Creation Error",
                message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style:
                UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // creates alert message that indicates all required values user didn't fill out 
    // in crowd creation
    func createCrowdAlertMsg() -> String {
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
        
        return alertMsg
    }
    
    // creates the final crowd from user input
    func createCrowd() -> Crowd {
        var crowd = Crowd()
        crowd.name = crowdNameText.text
        crowd.host = hostNameText.text
        crowd.threshold = Int(upvotesSlider.value)
        crowd.isPrivate = passwordProtectedSwitch.on
        crowd.password = passwordText.text
        return crowd
    }
    
    // updates button label depending on log in status
    func updateLoginButton() {
        if isLoggedIntoSpotify() {
            spotifyStatusLabel.text = "Spotify Status: Logged In"
            spotifyLoginBtn.setTitle("Log Out", forState: UIControlState.Normal)
        } else {
            spotifyStatusLabel.text = "Spotify Status: Logged Out"
            spotifyLoginBtn.setTitle("Log In", forState: UIControlState.Normal)
        }
    }


    // on user push log in/log out depending on current status
    @IBAction func spotifyBtnPressed(sender: AnyObject) {
        let auth = SPTAuth.defaultInstance()
        if isLoggedIntoSpotify() {
            auth.session = nil
            updateLoginButton()
        } else {
            openLoginPage()
        }
    }
    
    // SPOTIFY LOGIN FUNCTIONS
    
    // checks if logged into spotify
    func isLoggedIntoSpotify() -> Bool {
        let auth = SPTAuth.defaultInstance()
        if auth.session != nil && auth.session.isValid() {
            return true
        }
        return false
    }
    
    // updates login button when spotify session is updated
    func sessionUpdatedNotification(notification : NSNotification) {
        if self.navigationController?.topViewController == self {
            let auth = SPTAuth.defaultInstance()
            if (auth.session != nil && auth.session.isValid()) {
                updateLoginButton()
            }
        }
    }

    // spotify login failed
    func authenticationViewController(authenticationViewController: SPTAuthViewController!,
        didFailToLogin error: NSError!) {
        NSLog("*** Failed to log in \(error)")
        updateLoginButton()
    }

    // spotify login succeeds
    func authenticationViewController(authenticationViewController: SPTAuthViewController!,
        didLoginWithSession session: SPTSession!) {
        updateLoginButton()
        
    }
    
    // spotify login cancelled
    func authenticationViewControllerDidCancelLogin(authenticationViewController:
        SPTAuthViewController!) {
        updateLoginButton()
    }
    
    // open the spotify log in page
    func openLoginPage() {
        
        // create spotify login layout
        self.authViewController = SPTAuthViewController.authenticationViewController()
        self.authViewController?.delegate = self;
        self.authViewController?.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.authViewController?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.definesPresentationContext = false;
        
        // show spotify login page
        self.presentViewController(self.authViewController!, animated: false, completion: nil)
    }
    
    // renew spotify token if necessary
    func renewTokenAndShowButton() {
        let auth = SPTAuth.defaultInstance()
        
        auth.renewSession(auth.session,
            callback: { (error : NSError?, session : SPTSession?) -> () in
            auth.session = session
            
            if (error != nil) {
                NSLog("*** Error renewing session \(error)")
                return
            }
        })
    }
    
    // handles whether login view appears based on spotify login status
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
            return
        }
        
        if auth.hasTokenRefreshService {
            NSLog("renew Token!")
            
            self.renewTokenAndShowButton()
            return
        }
    }
    
    // NAVIGATION 
    
    // Creates the finalized crowd before changing screens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "finalizeCrowd" {
            var secondScene = segue.destinationViewController as CrowdTabViewController
            secondScene.myCrowd = createCrowd()
            
            // TODO: add crowd to database
            // TODO: figure out how not to go all the way back to crowd preferences
        }
    }
}