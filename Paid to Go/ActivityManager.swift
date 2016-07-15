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
    
    var activity : Activity = Activity()
    
    var poolId : String = ""
    
    var startDateToTrack : NSDate = NSDate()
    
    var trackNumber : Double = 0.0
    var milesCounter : Double = 0.0
    
    var endLatitude: Double = 0.0
    var endLongitude: Double = 0.0
    
    var startLatitude : Double = 0.0
    var startLongitude : Double = 0.0
    
    var initialLocation : CLLocation = CLLocation()
    var endLocation : CLLocation = CLLocation()
    
    var metersFromStartLocation : Double = 0.0
    var distanceToFinalDestination : Double = 0.0
    
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
    
    func getTrackNumber() -> Double {
        return trackNumber
    }
    
    func resetActivity() {
        trackNumber = 0.0
        activity = Activity()
        milesCounter = 0.0
        
        startLatitude = 0.0
        startLongitude = 0.0
        endLatitude = 0.0
        endLongitude = 0.0
        
        metersFromStartLocation = 0.0
        distanceToFinalDestination = 0.0
        
        poolId = ""
    }
}
