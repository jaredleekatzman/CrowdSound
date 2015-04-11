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
    @IBOutlet weak var privateCrowdSwitch: UISwitch!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confimPasswordText: UITextField!
    @IBOutlet weak var finalizeCrowdBtn: UIButton!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var passwordCell: UIView!
    
    @IBOutlet weak var passwordConfirmCell: UITableViewCell!
    
    @IBAction func upvoteSliderMoved(sender: AnyObject) {
        var sliderVal = Int(upvotesSlider.value)
        upvotesSlider.value = Float(sliderVal)
        upvotesLabel.text = "Upvotes: " + sliderVal.description
    }
    
    @IBAction func finalzeCrowdPushed(sender: AnyObject) {
        
    }
}
