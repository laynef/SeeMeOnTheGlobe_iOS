//
//  Student.swift
//  OnTheMap
//
//  Created by Layne Faler on 7/5/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

// MARK: - Student

struct Student {
    
    // MARK: Properties
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    var mediaURL: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // MARK: Initializers
    
    init(uniqueKey: String) {
        self.uniqueKey = uniqueKey
        firstName = ""
        lastName = ""
        mediaURL = ""
    }
    
    init(uniqueKey: String, firstName: String, lastName: String, mediaURL: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
    }
}