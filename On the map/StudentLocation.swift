//
//  Location.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import Foundation

class StudentLocation {
    
    static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static var locations: [StudentInformation] = []
    static var errors: [NSError] = []
    /**
    Gets the list of recently posted study locations.
    If locations are already loaded the function will returns without
    making a network request, unless forceRefresh is set to true

    - parameter forceRefresh: Force a refresh even if locations is not empty
    - parameter didComplete: Callback when loading is complete
    */
    class func getRecent(forceRefresh: Bool = false, didComplete: (success: Bool) -> Void) {
        if forceRefresh || locations.isEmpty {
            locations = []
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-createdAt")!)
            request.addValue(StudentLocation.appId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(StudentLocation.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil {
                    self.errors.append(error!)
                    didComplete(success: false)
                    return
                }
                let success = StudentLocation.parseLocationData(data!)
                didComplete(success: success)
            }
            task.resume()
        }
        else if !locations.isEmpty {
            didComplete(success: true)
        }
    }
    
    /**
    Parse the location data into StudentInformation structs

    - parameter data: The data from the request
    - returns: True if the data was successfully parsed.
    */
    class func parseLocationData(data: NSData) -> Bool {
        var success = false
        if let locationData = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as? NSDictionary {
            if let data = locationData["results"] as? [NSDictionary] {
                success = true
                for studentInfo in data {
                    if !StudentInformation.isDataValid(studentInfo) {
                        success = false
                        break
                    }
                    locations.append(StudentInformation(data: studentInfo))
                }
            }
        }
        if !success {
            errors.append(NSError(domain: "Location data could not be parsed.", code: 1, userInfo: nil))
        }
        return success
    }
    
    /**
    Create a new StudentLocation in the Parse database.

    - parameter latitude: The latitude for the new pin
    - parameter longitude: The longitude for the new pin
    - parameter mediaURL: The URL supplied by the user
    - parameter mapString: The place name provided by the user
    - parameter didComplete: The callback called when the network request completes
    */
    class func postNewLocation(latitude: Double, longitude: Double, mediaURL: String, mapString: String, didComplete: (success: Bool) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(StudentLocation.appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(StudentLocation.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyString = "{\"uniqueKey\": \"\(User.key)\", \"firstName\": \"\(User.firstName)\", \"lastName\": \"\(User.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errors.append(error!)
                didComplete(success: false)
                return
            }
            didComplete(success: true)
        }
        task.resume()
    }
}