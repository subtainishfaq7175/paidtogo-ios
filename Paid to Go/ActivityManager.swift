//
//  ActivityManager.swift
//  Paid to Go
//
//  Created by Nahuel on 23/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import CoreLocation

/// Handles the whole activity process, and the necessary information to update the progress circle

class ActivityManager: NSObject {
    
    var trackNumber : Double = 0.0
    var activity : Activity = Activity()
    var milesCounter : Double = 0.0
    
    var endLatitude: Double = 0.0
    var endLongitude: Double = 0.0
    
    var startLatitude : Double = 0.0
    var startLongitude : Double = 0.0
    
    var initialLocation : CLLocation = CLLocation()
    var endLocation : CLLocation = CLLocation()
    
    /**
     *  Singleton
     *
     *  We use a Singleton to allow a quick switch between the different Pool Types (Walk/Run, Bike and Bus/Train)
     *
     */
    static let sharedInstance = ActivityManager()
    
    private override init() {
        
    }
    
    func getMilesCounter() -> Double {
        return milesCounter
    }
    
    func setMilesCounter() {
        milesCounter += 1
    }
    
    func getTrackNumber() -> Double {
        return trackNumber
    }
    
    func setTrackNumber() {
        trackNumber += 0.05
    }
    
    func resetActivity() {
        trackNumber = 0.0
        activity = Activity()
        milesCounter = 0.0
        
        startLatitude = 0.0
        startLongitude = 0.0
    }
}
