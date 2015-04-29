//
//  CrowdTableViewControllerSpec.swift
//  CrowdSound
//
//  Created by Jared Katzman on 4/29/15.
//  Copyright (c) 2015 cs439. All rights reserved.
//

import UIKit
import Quick
import XCTest

class PendingTableViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController : PendingTableViewController!
        
        beforeEach {
                     viewController = PendingTableViewController()
            
            // Set up fixtures
                    viewController.crowd = Crowd.defaultCrowd()
        }
        
        describe("viewDidLoad()") {
            beforeEach {
                let _ = viewController.view
            }
            
            it("should display pending songs") {
                XCTAssertEqual(viewController.crowd!.pending.count(), viewController.tableView.numberOfRowsInSection(0))
            }
            
            
        }
        
//        describe("upvote button") {
//            beforeEach {
//                let _ = viewController.view
//                viewController.beginAppearanceTransition(true, animated: false)
//                viewController.endAppearanceTransition()
//            }
//            
//            it("increments upvotes of a song when clicked") {
//                let ind = 0
//                let path = NSIndexPath(forRow: ind, inSection: 0)
//                let cell = viewController.tableView.cellForRowAtIndexPath(path) as PendingSongCell
//                
//                let numVotes = viewController.crowd?.pending.songs[ind].upvotes
//                
//                cell.upvoteBttn.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
//                
//                XCTAssertEqual(numVotes! + 1, viewController.crowd!.pending.songs[ind].upvotes)
//                
//                
//            }
//        }
    
        
        
    }
}
