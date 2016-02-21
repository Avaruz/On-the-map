//
//  PostLocationViewController.swift
//  On the Map
//
//  Created by Adhemar Soria Galvarro on 25/1/16.
//  Copyright © 2016 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: BaseViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var locationEntryView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextContainer: UIView!
    @IBOutlet weak var geocodingIndicator: UIActivityIndicatorView!
    
    var location: CLLocation?
    var mapString: String = ""
    
    @IBAction func didPressCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTapTextContainer:")
        urlTextContainer.addGestureRecognizer(tapGesture)
        locationTextField.delegate = self
        urlTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func didTapTextContainer(sender: AnyObject) {
        urlTextField.becomeFirstResponder()
    }
    
    @IBAction func didPressFind(sender: UIButton) {
        
        let text = locationTextField.text
        if !text!.isEmpty {
            
            startGeoLoading()
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(text!, completionHandler: didCompleteGeocoding)
            
        }
    }
    
    /**
    Handle geocoding completion

    - parameter placemarks: Array of placemarks returned from geocoding
    - parameter error: Contains the error, if any ocurred
    */
    func didCompleteGeocoding(placemarks: [CLPlacemark]?, error: NSError?) {
        stopGeoLoading()
    
        if error == nil && placemarks!.count > 0 {
            // show the map
            locationEntryView.hidden = true
            mapContainerView.hidden = false
            
            // center the map and set the pin
            let placemark = placemarks![0] as CLPlacemark!
            let geocodedLocation = placemark.location!
            centerMapOnLocation(geocodedLocation)
            
            let studentInfo = StudentInformation(data: [
                "firstName": UdacityClient.firstName,
                "lastName": UdacityClient.lastName,
                "latitude": geocodedLocation.coordinate.latitude,
                "longitude": geocodedLocation.coordinate.longitude,
                "mediaURL": ""
                ])
            mapView.addAnnotation(studentInfo)
            
            // save for use during submit
            mapString = locationTextField.text!
            location = geocodedLocation
        } else {
            showErrorAlert("Error Geocoding", defaultMessage: "The supplied string could not be Geocoded", errors: [error!])
        }       
    }
    
    func startGeoLoading() {
        geocodingIndicator.startAnimating()
        locationEntryView.alpha = 0.5
    }
    
    func stopGeoLoading() {
        geocodingIndicator.stopAnimating()
        locationEntryView.alpha = 1
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentInformation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
            }
            return view
        }
        return nil
    }
    
    
    @IBAction func didPressSubmit(sender: UIButton) {
        if !urlTextField.text!.isEmpty && location != nil {
            let coord = location!.coordinate
            let text = urlTextField.text
            StudentLocation.postNewLocation(coord.latitude, longitude: coord.longitude, mediaURL: text!, mapString: mapString) { success in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    /**
    Centers the map on a location. From raywenderlich tutorial
    - parameter location: Where to center the map
    */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 20000, 20000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
