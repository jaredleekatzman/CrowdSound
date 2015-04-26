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

        // if user logged in already, move to next screen
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.performSegueWithIdentifier("GoToCrowdsList", sender: self)
        } else { // otherwise create UI for facebook login
            createFacebookLoginUI()
        }
    }
    
    // creates facebook UI/preferences for user login
    func createFacebookLoginUI() {
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
    }
    
    // FACEBOOK DELEGATE METHODS 
    
    // login was completed
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult
        result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        // check result of login
        if ((error) != nil) { // log in failed, make user log in again
            NSLog("FBLogin: error was found: \(error)")
        } else if result.isCancelled { // log in cancelled, make user log in again
            NSLog("FBLogin: result was cancelled!")
        } else { // login complete, move on to next screen
            self.performSegueWithIdentifier("GoToCrowdsList", sender: self)
        }
    }
    
    // user logged out
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        NSLog("User logged out")
    }
    
    // for delegate method: get user data
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                NSLog("Error: \(error)")
            } else {
                NSLog("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as NSString
                NSLog("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as NSString
                NSLog("User Email is: \(userEmail)")
            }
        })
    }
}

