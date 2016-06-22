//
//  DetailViewController.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var findOTMButton: BorderedButton!
    @IBOutlet weak var submitButton: BorderedButton!
    @IBOutlet weak var mapTextfield: UITextField!
    @IBOutlet weak var mediaURLTextfield: UITextField!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: LoginState
    
    private enum PostingState { case MapString, MediaURL }
    
    // MARK: Properties
    
    private let otmDataSource = OTMDataSource.sharedDataSource()
    private let parseClient = ParseCilent.sharedClient()
    private var placemark: CLPlacemark? = nil
    var objectID: String? = nil
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI(.MapString)
    }
    
    // MARK: Actions
    
    @IBAction func cancel(sender: AnyObject) {
        dismissController()
    }
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        // check for empty string
        if mapTextfield.text!.isEmpty {
            displayAlert(AppConstants.Errors.MapStringEmpty)
            return
        }
        
        // start activity indicator
        startActivity()
        
        // add placemark
        let delayInSeconds = 1.5
        let delay = delayInSeconds * Double(NSEC_PER_SEC)
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            let geocoder = CLGeocoder()
            do {
                geocoder.geocodeAddressString(self.mapTextfield.text!, completionHandler: { (results, error) in
                    if let _ = error {
                        self.displayAlert(AppConstants.Errors.CouldNotGeocode)
                    }
                    else if (results!.isEmpty){
                        self.displayAlert(AppConstants.Errors.NoLocationFound)
                    } else {
                        self.placemark = results![0]
                        self.configureUI(.MediaURL)
                        self.mapView.showAnnotations([MKPlacemark(placemark: self.placemark!)], animated: true)
                    }
                })
            }
        })
    }
    
    @IBAction func submitStudentLocation(sender: AnyObject) {
        
        // check for empty string
        if mediaURLTextfield.text!.isEmpty {
            displayAlert(AppConstants.Errors.URLEmpty)
            return
        }
        
        // check if student and placemark initialized
        guard let student = otmDataSource.currentStudent,
            let placemark = placemark,
            let postedLocation = placemark.location else {
                displayAlert(AppConstants.Errors.StudentAndPlacemarkEmpty)
                return
        }
        
        // define request handler
        let handleRequest: ((NSError?, String) -> Void) = { (error, mediaURL) in
            if let _ = error {
                self.displayAlert(AppConstants.Errors.PostStudentLocationFailed) { (alert) in
                    self.dismissController()
                }
            } else {
                self.otmDataSource.currentStudent!.mediaURL = mediaURL
                self.otmDataSource.refreshStudentLocations()
                self.dismissController()
            }
        }
        
        // init new values
        let location = Location(latitude: postedLocation.coordinate.latitude, longitude: postedLocation.coordinate.longitude, mapString: mapTextfield.text!)
        let mediaURL = mediaURLTextfield.text!
        
        if let objectID = objectID {
            parseClient.updateStudentLocationWithObjectID(objectID, mediaURL: mediaURL, studentLocation: StudentLocation(objectID: objectID, student: student, location: location)) { (success, error) in
                handleRequest(error, mediaURL)
            }
        } else {
            parseClient.postStudentLocation(mediaURL, studentLocation: StudentLocation(objectID: "", student: student, location: location)) { (success, error) in
                handleRequest(error, mediaURL)
            }
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(mapTextfield)
        resignIfFirstResponder(mediaURLTextfield)
    }
    
    // MARK: Display Alert
    
    private func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        dispatch_async(dispatch_get_main_queue()) {
            self.stopActivity()
            let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Default, handler: completionHandler))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Configure UI
    
    private func dismissController() {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    private func setupUI() {
        detailTitleLabel.textColor = AppConstants.UI.OTMBlueColor
        findOTMButton.setTitleColor(AppConstants.UI.OTMBlueColor, forState: .Normal)
        submitButton.setTitleColor(AppConstants.UI.OTMBlueColor, forState: .Normal)
        
        mapTextfield.delegate = self
        mediaURLTextfield.delegate = self
    }
    
    private func configureUI(state: PostingState, location: CLLocationCoordinate2D? = nil) {
        stopActivity()
        
        UIView.animateWithDuration(1.0) {
            switch(state) {
            case .MapString:
                self.topStackView.backgroundColor = AppConstants.UI.OTMGreyColor
                self.middleStackView.backgroundColor = AppConstants.UI.OTMBlueColor
                self.bottomStackView.backgroundColor = AppConstants.UI.OTMGreyColor
                self.mediaURLTextfield.hidden = true
                self.mapTextfield.hidden = false
                self.cancelButton.setTitleColor(AppConstants.UI.OTMBlueColor, forState: .Normal)
                self.submitButton.hidden = true
                self.detailTitleLabel.hidden = false
            case .MediaURL:
                if let location = location {
                    self.mapView.centerCoordinate = location
                }
                self.topStackView.backgroundColor = AppConstants.UI.OTMBlueColor
                self.middleStackView.backgroundColor = UIColor.clearColor()
                self.bottomStackView.backgroundColor = AppConstants.UI.OTMBlueColor
                self.mediaURLTextfield.hidden = false
                self.mapTextfield.hidden = true
                self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.findOTMButton.hidden = true
                self.submitButton.hidden = false
                self.detailTitleLabel.hidden = true
            }
        }
    }
    
    // MARK: Configure UI (Activity)
    
    private func startActivity() {
        setFindingUIEnabled(false)
        setFindingUIAlpha(0.5)
    }
    
    private func stopActivity() {
        setFindingUIEnabled(true)
        setFindingUIAlpha(1.0)
    }
    
    private func setFindingUIEnabled(enabled: Bool) {
        mapTextfield.enabled = enabled
        findOTMButton.enabled = enabled
        cancelButton.enabled = enabled
        detailTitleLabel.enabled = enabled
    }
    
    private func setFindingUIAlpha(alpha: CGFloat) {
        mapTextfield.alpha = alpha
        findOTMButton.alpha = alpha
        cancelButton.alpha = alpha
        detailTitleLabel.alpha = alpha
    }
}

// MARK: - OTMPostingViewController: UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
