//
//  ConfigTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 4/10/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class ConfigTableViewController: UITableViewController {

    @IBOutlet weak var crowdNameText: UITextField!
    @IBOutlet weak var hostNameText: UITextField!
    @IBOutlet weak var upvotesSlider: UISlider!
    @IBOutlet weak var finalizeCrowdBtn: UIButton!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordProtectedSwitch: UISwitch!
    
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
