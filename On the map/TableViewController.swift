//
//  SecondViewController.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit

class TableViewController: LocationViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocationData() {
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRefreshLocationData", name: refreshNotificationName, object: nil)
    }
    
    func didRefreshLocationData() {
        tableView.reloadData()
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as UITableViewCell!
        if  ParseClient.sharedInstance.locations.count > indexPath.row {
            let studentInfo = ParseClient.sharedInstance.locations[indexPath.row]
            cell.textLabel!.text = studentInfo.title
            cell.imageView!.image = UIImage(named: "pin")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance.locations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  ParseClient.sharedInstance.locations.count > indexPath.row {
            let studentInfo = ParseClient.sharedInstance.locations[indexPath.row]
            if let url = NSURL(string: studentInfo.mediaURL) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }


}

