//
//  Location.swift
//  OnTheMap
//
//  Created by Layne Faler on 7/5/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
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
