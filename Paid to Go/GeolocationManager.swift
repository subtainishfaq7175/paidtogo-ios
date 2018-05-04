//
//  GeolocationManager.swift
//  Paid to Go
//
//  Created by Nahuel on 18/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import CoreLocation

class GeolocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = GeolocationManager()
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    private override init() {}
    
    static func initLocationManager() {
        sharedInstance.locationManager.delegate = sharedInstance.self
        sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        sharedInstance.locationManager.requestAlwaysAuthorization()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func pauseLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            startLocationUpdates()
        } else {
            print("User didn't authorize the app to use the current location.")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        pauseLocationUpdates()
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        currentLocation = locationObj
    }
    
    static func getCurrentLocation() -> CLLocation {
        return sharedInstance.currentLocation
    }
    
    static func getCurrentLocationCoordinate() -> CLLocationCoordinate2D {
        return sharedInstance.currentLocation.coordinate
    }
    
}
