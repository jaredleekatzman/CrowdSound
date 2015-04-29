////
////  CrowdTableViewControllerSpec.swift
////  CrowdSound
////
////  Created by Jared Katzman on 4/29/15.
////  Copyright (c) 2015 cs439. All rights reserved.
////
//
//import UIKit
//import Quick
//import XCTest
//
//class CrowdTableViewControllerSpec: QuickSpec {
//    override func spec() {
//        var viewController : CrowdsTableViewController!
//        beforeEach {
////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////            viewController = storyboard.instantiateViewControllerWithIdentifier("CrowdsTableViewControllerID") as CrowdsTableViewController
////            
//            viewController = CrowdsTableViewController()
//            
//            // Set up fixtures
//            // Details:
//            //
//            viewController.crowds = Crowd.createDummyCrowds()
//        }
//    
//        describe("viewDidLoad()") {
//            beforeEach {
//                // Method #1: Access the view to trigger CrowdsTableViewController.viewDidLoad()
//                let _ = viewController.view
//            }
//            
//            it("loads all the default crowds") {
//                XCTAssertEqual(viewController.crowds.count, viewController.tableView.numberOfRowsInSection(0))
//            }
//            
//        }
//        
//        describe("searchDelegate") {
//            beforeEach {
//                let _ = viewController.view
//        }
//            it("doesn't filter with input of empty text") {
//                viewController.crowdSearchController.searchBar.text = ""
//                XCTAssertEqual(viewController.crowds.count, viewController.tableView.numberOfRowsInSection(0))
//            }
//            
//        }
//     
//        
//        
//    }
//}
