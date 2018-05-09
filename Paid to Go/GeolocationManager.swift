
//
//  GeolocationManager.swift
//  Paid to Go
//
//  Created by Nahuel on 18/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import CoreLocation

class GeolocationManager: NSObject {
//    Singalton Implementations
    static let sharedInstance = GeolocationManager()
    private override init() {}

    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    
     func initLocationManager() {
        if (CLLocationManager.locationServicesEnabled()){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse,.authorizedAlways:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            break
        default:
            print(Constants.consShared.APP_NAME,"app not authorized for loacation")
            break
        }
        }else {
            print(Constants.consShared.APP_NAME,"Location services not enabled for this app")

        }
        print("on viewDidLoad Location is \(currentLocation.coordinate.latitude) and \(currentLocation.coordinate.longitude)")    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func pauseLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
  
    
    func getCurrentLocation() -> CLLocation {
        return currentLocation
    }
    
    func getCurrentLocationCoordinate() -> CLLocationCoordinate2D {
        return currentLocation.coordinate
    }
    
}
extension GeolocationManager : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == CLAuthorizationStatus.authorizedAlways {
            startLocationUpdates()
        } else {
            print("User didn't authorize the app to use the current location.")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        pauseLocationUpdates()
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        currentLocation = locationObj
    }
}
