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
    var selectedCrowd : Crowd? = nil

    var searchArray:[Crowd] = [Crowd](){
        didSet  {self.tableView.reloadData()}
    }
    
    var crowdSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sessionUpdateNotification:", name:
            "sessionUpdated", object: nil)

        self.crowds = Crowd.createDummyCrowds()
        
        // Configure countrySearchController
        self.crowdSearchController = ({

            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle  = UIBarStyle.Black
            controller.searchBar.tintColor = self.view.tintColor
            
            
            self.tableView.tableHeaderView = controller.searchBar
            self.definesPresentationContext = true
            
            
            return controller
        })()
        
        // UI Code: Set 'Bounce Area' background to be black
        let topView = UIView(frame: CGRectMake(0, -480, 500, 480))
        topView.backgroundColor = UIColor.blackColor()
        self.tableView.addSubview(topView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TABLE VIEW DATA SOURCE

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of search results or the total number of crowds.
        if (self.crowdSearchController.active) {
            return self.searchArray.count
        }
        return crowds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("crowdCell", forIndexPath: indexPath) as UITableViewCell

        // cell takes search results if searching...
        if (self.crowdSearchController.active) {
            cell.textLabel?.text = self.searchArray[indexPath.row].name
        } else { // ... or all crowds if not.
            var currentCrowd = crowds[indexPath.row]
            cell.textLabel?.text = currentCrowd.name
        }
        cell.textLabel?.textColor = UIColor.whiteColor()

        return cell
    }
    
    // update tableView with results as typing.
    //  maintain array of crowd objects analogous to search results.
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchArray.removeAll(keepCapacity: false)
        var crowdNames = crowds as NSArray
        if searchController.searchBar.text == "" {
            self.searchArray = crowdNames as [Crowd]
        } else {
            let searchPredicate = NSPredicate(format: "self.name CONTAINS[c] %@", searchController.searchBar.text)
            var array = crowdNames.filteredArrayUsingPredicate(searchPredicate!)
            self.searchArray = array as [Crowd]
        }

        
    }
    
    // MARK: - NAVIGATION

    // prepare to move screens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if user clicked crowd, pass on crowd data to next view
        if segue.identifier? == "showCrowd" {
            var secondScene = segue.destinationViewController as CrowdTabViewController
            // Pass the selected object to the new view controller.
            if selectedCrowd != nil {
                secondScene.myCrowd = selectedCrowd
            }
        }
    }
    
    // determines if segue should show
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {

        if identifier == "showCrowd" {
            
            if correctPassword { // if correct password, do segue
                return true
            }
            crowdSelectedByUser()
            if selectedCrowd != nil {
                if !selectedCrowd!.isPrivate {   // if not private, always return true
                    return true
                } else {                        // otherwise wait for correct response
                    showPasswordInputView()
                    return false
                }
            }
        }
        

        return true
    }
    
    // sets the global crowdSelected to the crowd object picked by the user.
    func crowdSelectedByUser() {
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            
            // find proper crowd.
            if (self.crowdSearchController.active) {
                selectedCrowd = searchArray[indexPath.row]
                
                // reset search defaults.
                self.crowdSearchController.active = false
                self.crowdSearchController.searchBar.text = ""
            } else {
                selectedCrowd = crowds[indexPath.row]
            }
            // reset table default.
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            selectedCrowd = nil
        }
    }
    
    // MARK: - PASSWORD FUNCTIONS
    
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
            break
        case 1:
            checkPassword(View) // Done clicked
            break
        default:                // Cancel clicked
            break
        }
    }
    
    // checks user input with crowd password, else shows alert
    func checkPassword(view: UIAlertView!) {
        let userInput = view.textFieldAtIndex(0)?.text
        if let crowdToCheck = selectedCrowd {
            if crowdToCheck.password == userInput {
                correctPassword = true
                performSegueWithIdentifier("showCrowd", sender: self)
            } else {
                selectedCrowd = nil
                showPasswordIncorrectAlert()
            }
        }

        correctPassword = false
    }
    
    // shows alert message when user inputs incorrect password
    func showPasswordIncorrectAlert() {
        
        var alert = UIAlertController(title: "Incorrect Password",
            message: "The password you entered was incorrect", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    override func viewWillDisappear(animated: Bool) {
        // remove password and crowd memory
        correctPassword = false
        selectedCrowd = nil
    }
}
