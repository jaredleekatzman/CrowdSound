//
//  CrowdsTableViewController.swift
//  CrowdSound
//
//  Created by Terin Patel-Wilson on 3/6/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit

class CrowdsTableViewController: UITableViewController, UISearchResultsUpdating, UIAlertViewDelegate {

    @IBOutlet var configButton: UIBarButtonItem!
    
    var crowds = [Crowd]()
    var correctPassword = false

    var searchArray:[String] = [String](){
        didSet  {self.tableView.reloadData()}
    }
    
    var crowdSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionUpdateNotification:", name:
            "sessionUpdated", object: nil)

        createDummyCrowds()
        
        // Configure countrySearchController
        self.crowdSearchController = ({

            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    

    
    // for testing: create dummy crowds
    func createDummyCrowds() {
        var springFling = Crowd.defaultCrowd()
        springFling.name = "Spring Fling Playlist"
        springFling.isPrivate = true
        springFling.password = "spring fling"
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

    // MARK: - TABLE VIEW DATA SOURCE

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if (self.crowdSearchController.active) {
            return self.searchArray.count
        }
        return crowds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("crowdCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if (self.crowdSearchController.active) {
            cell.textLabel?.text = self.searchArray[indexPath.row]
        } else {
            var currentCrowd = crowds[indexPath.row]
            cell.textLabel?.text = currentCrowd.name
        }
        
        return cell
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchArray.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        var array = (crowds.map{a in a.name} as NSArray).filteredArrayUsingPredicate(searchPredicate!)
        self.searchArray = array as [String]
        
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }

    
    // MARK: - NAVIGATION

    // prepare to move screens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if user clicked crowd, pass on crowd data to next view
        if segue.identifier? == "showCrowd" {
            var secondScene = segue.destinationViewController as CrowdTabViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                self.crowdSearchController.active = false
                let selectedCrowd = crowds[indexPath.row]
                secondScene.myCrowd = selectedCrowd
                //self.crowdSearchController.active = false
            }
        }
    }
    
    // MARK: - PASSWORD FUNCTIONS
    
    // determines if segue should show
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {

        if identifier == "showCrowd" {
            if correctPassword { // if correct password, do segue
                return true
            }
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let selectedCrowd = crowds[indexPath.row]
                if !selectedCrowd.isPrivate {   // if not private, always return true
                    return true
                } else {                        // otherwise wait for correct response
                    showPasswordInputView()
                    return false
                }
            }
        }
        return true
    }
    
    // show the password alert view
    func showPasswordInputView() {
        var passwordAlert = UIAlertView()
        passwordAlert.becomeFirstResponder()
        passwordAlert.title = "Crowd is private, please enter password:"
        passwordAlert.addButtonWithTitle("Cancel")
        passwordAlert.addButtonWithTitle("Done")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.delegate = self
        passwordAlert.show()
    }
    
    // deals with button clicks for password alert view.
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0: // user hit cancel
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            break
        case 1:
            checkPassword(View) // Done clicked
            break
        default:                // Cancel clicked
            println("default")
            break
        }
    }
    
    // make the textfield in the alertView the foxus
    // TODO: this doesn't work. see if simulator issue.
    func didPresentAlertView(alertView: UIAlertView) {
        alertView.textFieldAtIndex(0)?.becomeFirstResponder()
    }
    
    // checks user input with crowd password, else shows alert
    func checkPassword(view: UIAlertView!) {
        let userInput = view.textFieldAtIndex(0)?.text
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let selectedCrowd = crowds[indexPath.row]
            if selectedCrowd.password == userInput {
                correctPassword = true
                performSegueWithIdentifier("showCrowd", sender: self)
            } else {
                showPasswordIncorrectAlert()
            }
        }
        correctPassword = false
    }
    
    // shows alert message when user inputs incorrect password
    func showPasswordIncorrectAlert() {
        
        // display alert about incorrect password
        var alert = UIAlertController(title: "Incorrect Password",
            message: "The password you entered was incorrect", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        // deselect the selected row
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    

    override func viewWillDisappear(animated: Bool) {
        correctPassword = false // remove password memory
    }
}
