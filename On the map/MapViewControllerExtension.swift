//
//  MapViewControllerExtension.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//
//  Some ideas from http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

import Foundation
import MapKit

extension MapViewController {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? StudentInformation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        view.addGestureRecognizer(tapGesture)
        selectedView = view
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        selectedView = nil
        view.removeGestureRecognizer(tapGesture)
    }
    
    func calloutTapped(sender: MapViewController) {
        if let studentInfo = selectedView!.annotation as? StudentInformation,
            let url = NSURL(string: studentInfo.mediaURL)
        {
                UIApplication.sharedApplication().openURL(url)
        }
    }
}