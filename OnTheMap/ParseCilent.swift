//
//  ParseCilent.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class ParseCilent: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    // MARK: Properties
    
    let apiSession: APISession
    
    // MARK: Initializer
    
    override init() {
        let apiData = APIData(scheme: ParseComponents.Scheme, host: ParseComponents.Host, path: ParseComponents.Path, domain: ParseErrors.Domain)
        apiSession = APISession(apiData: apiData)
    }
    
    // MARK: Singleton Instance
    
    private static var sharedInstance = ParseCilent()
    
    class func sharedClient() -> ParseCilent {
        return sharedInstance
    }
    
    // MARK: Make Request
    
    private func makeRequestForParse(url url: NSURL, method: HTTPMethod, body: [String:AnyObject]? = nil, responseHandler: (jsonAsDictionary: [String:AnyObject]?, error: NSError?) -> Void) {
        
        let headers = [
            ParseHeaderKeys.AppId: ParseHeaderValues.AppId,
            ParseHeaderKeys.APIKey: ParseHeaderValues.APIKey,
            ParseHeaderKeys.Accept: ParseHeaderValues.JSON,
            ParseHeaderKeys.ContentType: ParseHeaderValues.JSON
        ]
        
        apiSession.makeRequestAtURL(url, method: method, headers: headers, body: body) { (data, error) in
            if let data = data {
                let jsonAsDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject]
                responseHandler(jsonAsDictionary: jsonAsDictionary, error: nil)
            } else {
                responseHandler(jsonAsDictionary: nil, error: error)
            }
        }
    }
    
    // MARK: GET Student Location
    
    func studentLocationWithUserKey(userKey: String, completionHandler: (location: StudentLocation?, error: NSError?) -> Void) {
        
        let studentLocationURL = apiSession.urlForMethod(ParseObjects.StudentLocation, parameters: [
            ParseParameterKeys.Where: "{\"\(ParseParameterKeys.UniqueKey)\":\"" + "\(userKey)" + "\"}"
            ])
        
        makeRequestForParse(url: studentLocationURL, method: .GET) { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(location: nil, error: error)
                return
            }
            
            if let jsonAsDictionary = jsonAsDictionary,
                let studentDictionaries = jsonAsDictionary[ParseJSONResponseKeys.Results] as? [[String:AnyObject]] {
                if studentDictionaries.count == 1 {
                    completionHandler(location: StudentLocation(dictionary: studentDictionaries[0]), error: nil)
                    return
                }
            }
            
            completionHandler(location: nil, error: self.apiSession.errorWithStatus(0, description: ParseErrors.NoRecordAtKey))
        }
    }
    
    // MARK: GET Student Locations
    
    func studentLocations(completionHandler: (locations: [StudentLocation]?, error: NSError?) -> Void) {
        
        let studentLocationURL = apiSession.urlForMethod(ParseObjects.StudentLocation, parameters: [
            ParseParameterKeys.Limit: ParseParameterValues.OneHundred,
            ParseParameterKeys.Order: ParseParameterValues.MostRecentlyUpdated
            ])
        
        makeRequestForParse(url: studentLocationURL, method: .GET) { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(locations: nil, error: error)
                return
            }
            
            if let jsonAsDictionary = jsonAsDictionary,
                let studentDictionaries = jsonAsDictionary[ParseJSONResponseKeys.Results] as? [[String:AnyObject]] {
                completionHandler(locations: StudentLocation.locationsFromDictionaries(studentDictionaries), error: nil)
                return
            }
            
            completionHandler(locations: nil, error: self.apiSession.errorWithStatus(0, description: ParseErrors.NoRecords))
        }
    }
    
    // MARK: POST Student Location
    
    func postStudentLocation(mediaURL: String, studentLocation: StudentLocation, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        let studentLocationURL = apiSession.urlForMethod(ParseObjects.StudentLocation)
        let studentLocationBody: [String:AnyObject] = [
            BodyKeys.UniqueKey: studentLocation.student.uniqueKey,
            BodyKeys.FirstName: studentLocation.student.firstName,
            BodyKeys.LastName: studentLocation.student.lastName,
            BodyKeys.MapString: studentLocation.location.mapString,
            BodyKeys.MediaURL: mediaURL,
            BodyKeys.Latitude: studentLocation.location.latitude,
            BodyKeys.Longitude: studentLocation.location.longitude
        ]
        
        makeRequestForParse(url: studentLocationURL, method: .POST, body: studentLocationBody) { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(success: false, error: error)
                return
            }
            
            // success
            if let jsonAsDictionary = jsonAsDictionary,
                let _ = jsonAsDictionary[ParseJSONResponseKeys.ObjectID] as? String {
                completionHandler(success: true, error: nil)
                return
            }
            
            // known failure
            if let jsonAsDictionary = jsonAsDictionary,
                let error = jsonAsDictionary[ParseJSONResponseKeys.Error] as? String {
                completionHandler(success: true, error: self.apiSession.errorWithStatus(0, description: error))
                return
            }
            
            // unknown failure
            completionHandler(success: false, error: self.apiSession.errorWithStatus(0, description: ParseErrors.CouldNotPostLocation))
        }
    }
    
    // MARK: PUT Student Location
    
    func updateStudentLocationWithObjectID(objectID: String, mediaURL: String, studentLocation: StudentLocation, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        let studentLocationURL = apiSession.urlForMethod(ParseObjects.StudentLocation, withPathExtension: "/\(objectID)")
        let studentLocationBody: [String:AnyObject] = [
            BodyKeys.UniqueKey: studentLocation.student.uniqueKey,
            BodyKeys.FirstName: studentLocation.student.firstName,
            BodyKeys.LastName: studentLocation.student.lastName,
            BodyKeys.MapString: studentLocation.location.mapString,
            BodyKeys.MediaURL: mediaURL,
            BodyKeys.Latitude: studentLocation.location.latitude,
            BodyKeys.Longitude: studentLocation.location.longitude
        ]
        
        makeRequestForParse(url: studentLocationURL, method: .PUT, body: studentLocationBody) { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(success: false, error: error)
                return
            }
            
            // success
            if let jsonAsDictionary = jsonAsDictionary,
                let _ = jsonAsDictionary[ParseJSONResponseKeys.UpdatedAt] {
                completionHandler(success: true, error: nil)
                return
            }
            
            // known failure
            if let jsonAsDictionary = jsonAsDictionary,
                let error = jsonAsDictionary[ParseJSONResponseKeys.Error] as? String {
                completionHandler(success: true, error: self.apiSession.errorWithStatus(0, description: error))
                return
            }
            
            // unknown failure
            completionHandler(success: false, error: self.apiSession.errorWithStatus(0, description: ParseErrors.CouldNotUpdateLocation))
        }
    }

}
