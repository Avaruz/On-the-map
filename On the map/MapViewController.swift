//
//  FirstViewController.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: LocationViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    /// The selected annotation view
    var selectedView: MKAnnotationView?
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: "calloutTapped:")
        loadLocationData() {
            self.loadAnnotations()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRefreshLocationData", name: refreshNotificationName, object: nil)
    }
    
    func didRefreshLocationData() {
        self.mapView.removeAnnotations(StudentLocation.locations)
        self.loadAnnotations()
    }
   

    func loadAnnotations() {
        let coord = StudentLocation.locations[0].coordinate
        let initialLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        centerMapOnLocation(initialLocation)
        for location in StudentLocation.locations {
            mapView.addAnnotation(location)
        }                  
    }
    

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000000, 2000000)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

