//
//  StudentLocations.swift
//  On the map
//
//  Created by Adhemar Soria Galvarro on 23/2/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import Foundation


class StudentsLocations{
    var locations: [StudentInformation] = []
    
    static let sharedInstance = StudentsLocations()
    
    private init(){
        print(__FUNCTION__)
    }
}
    