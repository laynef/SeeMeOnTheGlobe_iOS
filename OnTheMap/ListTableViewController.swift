//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let otmDataSource = OTMDataSource.sharedDataSource()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = otmDataSource
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(studentLocationsDidUpdate), name: "\(ParseCilent.ParseObjects.StudentLocation)\(ParseCilent.ParseNotifications.ObjectUpdatedError)", object: nil)
    }
    
    // MARK: Data Source
    
    func studentLocationsDidUpdate() {
        tableView.reloadData()
    }
    
    // MARK: Display Alert
    
    private func displayAlert(message: String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let studentMediaURL = otmDataSource.studentLocations[indexPath.row].student.mediaURL
        
        if let mediaURL = NSURL(string: studentMediaURL) {
            if UIApplication.sharedApplication().canOpenURL(mediaURL) {
                UIApplication.sharedApplication().openURL(mediaURL)
            } else {
                displayAlert(AppConstants.Errors.CannotOpenURL)
            }
        }
    }
}
