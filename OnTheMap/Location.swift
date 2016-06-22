//
//  Location.swift
//  OnTheMap
//
//  Created by Jarrod Parkes on 11/8/15.
//  Copyright © 2015 JarrodParkes. All rights reserved.
//

import MapKit

// MARK: - Location

struct Location {
    
    // MARK: Properties
    
    let latitude: Double
    let longitude: Double
    let mapString: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}