//
//  CLLocationManager+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 29/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationManager {
    
    static func getDistanceBetweenLocations(locA:CLLocation, locB:CLLocation) -> Double {
        let distance : CLLocationDistance = locA.distance(from: locB)
        
        return distance
    }
}
