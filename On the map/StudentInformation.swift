//
//  StudentInformation.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import Foundation
import MapKit


struct StudentInformation {
    var coordinate: CLLocationCoordinate2D
    var firstName: String
    var lastName: String
    var mediaURL: String
    
    var title: String?
    var subtitle: String?
    
    init(data: NSDictionary) {
        coordinate = CLLocationCoordinate2D(
            latitude: data["latitude"] as! Double!,
            longitude: data["longitude"] as! Double
        )
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        mediaURL = data["mediaURL"] as! String
        
        title = "\(firstName) \(lastName)"
        subtitle = mediaURL
    }
    
    func toMKAnnotation()-> MapPin {
        return MapPin(coordinate: self.coordinate, title: self.title!, subtitle:self.subtitle!)
    }
    
    static func isDataValid(data: NSDictionary) -> Bool {
        if let _ = data["latitude"] as? Double,
            let _ = data["longitude"] as? Double,
            let _ = data["firstName"] as? String,
            let _ = data["lastName"] as? String,
            let _ = data["mediaURL"] as? String
        {
            return true
        }
        return false
    }
}

