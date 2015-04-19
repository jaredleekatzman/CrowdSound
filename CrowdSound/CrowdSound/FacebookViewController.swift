//
//  FacebookViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/19/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class FacebookViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User already logged in
            NSLog("user already logged in, should move on!")
            self.performSegueWithIdentifier("GoToCrowdsList", sender: self)
        } else {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // facebook delegate methods 
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        NSLog("User logged in")

        if ((error) != nil) {
            NSLog("FBLogin: error was found")
            // process error
        } else if result.isCancelled {
            NSLog("FBLogin: result was cancelled!")
            self.performSegueWithIdentifier("GoToCrowdsList", sender: self)
        } else {
            NSLog("user logged in, moving to next screen")
            self.performSegueWithIdentifier("GoToCrowdsList", sender: self)
            
            // if you ask for multiple permissions at once, check if
            // specific permissions missing 
            if result.grantedPermissions.containsObject("email") {
                // do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        NSLog("User logged out")
    }
    
    // if want user data call this when they're logged in
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                NSLog("Error: \(error)")
            }
            else
            {
                NSLog("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as NSString
                NSLog("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as NSString
                NSLog("User Email is: \(userEmail)")
            }
        })
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
