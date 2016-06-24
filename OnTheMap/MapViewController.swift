//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var mainMapView: MKMapView!
    
    // MARK: Properties
    
    let otmDataSource = OTMDataSource.sharedDataSource()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMapView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(studentLocationsDidUpdate), name: "\(ParseCilent.ParseObjects.StudentLocation)\(ParseCilent.ParseNotifications.ObjectUpdated)", object: nil)
        otmDataSource.refreshStudentLocations()
    }
    
    // MARK: Data Source
    
    func studentLocationsDidUpdate() {
        
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in otmDataSource.studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = studentLocation.location.coordinate
            annotation.title = studentLocation.student.fullName
            annotation.subtitle = studentLocation.student.mediaURL
            annotations.append(annotation)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mainMapView.removeAnnotations(self.mainMapView.annotations)
            self.mainMapView.addAnnotations(annotations)
        }
    }
    
    // MARK: Display Alert
    
    private func displayAlert(message: String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}

// MARK: - OTMMapViewController: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "Pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = NSURL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.sharedApplication().canOpenURL(mediaURL) {
                    UIApplication.sharedApplication().openURL(mediaURL)
                } else {
                    displayAlert(AppConstants.Errors.CannotOpenURL)
                }
            }
        }
    }
}