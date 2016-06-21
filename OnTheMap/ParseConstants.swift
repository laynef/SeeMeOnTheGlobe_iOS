//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

struct ParseConstants {
    static let apiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let appId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let baseURL: String = "https://api.parse.com/1/classes/StudentLocation"
}

struct ParseResponseKeys {
    static let results: String = "results"
    static let error: String = "error"
    
    static let createdAt: String = "createdAt"
    static let firstName: String = "firstName"
    static let lastName: String = "lastName"
    static let latitude: String = "latitude"
    static let longitude: String = "longitude"
    static let mapString: String = "mapString"
    static let mediaURL: String = "mediaURL"
    static let objectId: String = "objectId"
    static let uniqueKey: String = "uniqueKey"
    static let updatedAt: String = "updatedAt"
}

struct ParseStudentLocation: CustomStringConvertible {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    
    var description: String {
        return "ParseStudentLocation: \(objectId)-\(uniqueKey)"
    }
    
}