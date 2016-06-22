//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jarrod Parkes on 11/8/15.
//  Copyright © 2015 JarrodParkes. All rights reserved.
//

// MARK: - StudentLocation

struct StudentLocation {
    
    // MARK: Properties
    
    let objectID: String
    let student: Student
    let location: Location
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        
        objectID = dictionary[ParseCilent.ParseJSONResponseKeys.ObjectID] as? String ?? ""
        
        // get student data
        let uniqueKey = dictionary[ParseCilent.ParseJSONResponseKeys.UniqueKey] as? String ?? ParseCilent.ParseDefaultValues.ObjectID
        let firstName = dictionary[ParseCilent.ParseJSONResponseKeys.FirstName] as? String ?? ParseCilent.ParseDefaultValues.FirstName
        let lastName = dictionary[ParseCilent.ParseJSONResponseKeys.LastName] as? String ?? ParseCilent.ParseDefaultValues.LastName
        let mediaURL = dictionary[ParseCilent.ParseJSONResponseKeys.MediaURL] as? String ?? ParseCilent.ParseDefaultValues.MediaURL
        student = Student(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mediaURL: mediaURL)
        
        // get location data
        let latitude = dictionary[ParseCilent.ParseJSONResponseKeys.Latitude] as? Double ?? 0.0
        let longitude = dictionary[ParseCilent.ParseJSONResponseKeys.Longitude] as? Double ?? 0.0
        let mapString = dictionary[ParseCilent.ParseJSONResponseKeys.MapString] as? String ?? ParseCilent.ParseDefaultValues.MapString
        location = Location(latitude: latitude, longitude: longitude, mapString: mapString)
    }
    
    init(student: Student, location: Location) {
        objectID = ""
        self.student = student
        self.location = location
    }
    
    init(objectID: String, student: Student, location: Location) {
        self.objectID = objectID
        self.student = student
        self.location = location
    }
    
    // MARK: Convenience "Initializers"
    
    static func locationsFromDictionaries(dictionaries: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        for studentDictionary in dictionaries {
            studentLocations.append(StudentLocation(dictionary: studentDictionary))
        }
        return studentLocations
    }
}
