//
//  LocationViewController.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit

/// Shared functionality for map and table view
class LocationViewController: UIViewController {
    
    @IBOutlet var pinButtonItem: UIBarButtonItem!
    @IBOutlet var refreshButtonItem: UIBarButtonItem!
    
    // allows subclass-specific refresh handler
    let refreshNotificationName = "Location Data Refresh Notification"
    
     override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButtonItems([refreshButtonItem, pinButtonItem], animated: false)
    }
    
    @IBAction func didPressRefresh(sender: UIBarButtonItem) {
        self.loadLocationData(true) {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: self.refreshNotificationName, object: self))
        }
    }
    
    @IBAction func didPressLogout(sender: UIBarButtonItem) {
        sender.enabled = false
        UdacityClient.sharedInstance.logOut() { success in
            if FBSDKAccessToken.currentAccessToken() != nil {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            sender.enabled = true
            if !success {
                self.showErrorAlert("Logout Failed", defaultMessage: "Could not log out", errors: UdacityClient.sharedInstance.errors)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func didPressPin(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showPost", sender: self)
    }
    
    /**
    Loads location data or displays an error message if the data cannot be loaded.
    
    - parameter forceRefresh: Force the data to be retrieved over the network
    */
    internal func loadLocationData(forceRefresh: Bool = false, didComplete: (() -> Void)?) {
         ParseClient.sharedInstance.getRecent(forceRefresh) { success in
            if !success {
                self.showErrorAlert("Error Loading Locations", defaultMessage: "Loading failed.", errors: ParseClient.sharedInstance.errors)
            } else if !StudentsLocations.sharedInstance.locations.isEmpty && didComplete != nil {
                didComplete!()
            }
        }       
    }
    
}
