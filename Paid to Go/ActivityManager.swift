//
//  ActivityManager.swift
//  Paid to Go
//
//  Created by Nahuel on 23/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

// MARK: - Protocol -

protocol ActivityTest {
    
    var testCounter : Int { get set }
    var testCounterRejected : Int { get set }
    
    static func getTestCounter() -> Int
    static func setTestCounter()
    static func getTestCounterRejected() -> Int
    static func setTestCounterRejected()
}

// MARK: - Class -

/* 
 *  Handles the whole activity process, and the necessary information to update the progress circle
 */
class ActivityManager: NSObject, ActivityTest {
    
    /**
     *  Singleton
     *
     *  We use a shared instance to ease the access and update of the activite's information.
     *  The activitie's information can be updated from the pool screen and also from the map screen.
     *
     */
    static let sharedInstance = ActivityManager()
    
    private override init() {
        
    }
    
    // MARK: - Attributes -
    
    /*
     *  Conversion from meters to miles
     */
    internal static let metersToMiles = 0.000621371
    
    /*
     *  Attributes required by the API to register an activity
     */
    var activity : Activity = Activity()
    var poolId : String = ""
    var startDateToTrack : NSDate = NSDate()
    var milesCounter : Double = 0.0
    var endLatitude: Double = 0.0
    var endLongitude: Double = 0.0
    var startLatitude : Double = 0.0
    var startLongitude : Double = 0.0
    
    /* 
     *  The last updated location. Every new location updated is compared with the last updated location 
     */
    var lastLocation : CLLocation = CLLocation()
    
    /*
     *  The previous location. Used instead of lastLocation to avoid issues after pausing and resuming an activity
     */
    var lastSubrouteInitialLocation : CLLocation = CLLocation()
    
    /*
     *  Array containing the subroutes that will be drawn on the map
     */
    var subroutes = [MKPolyline]()
    var mapIsMainScreen : Bool = false
    
    /**
     *  Indicates if the pool has been paused at least once
     */
    var pausedAndResumedActivity = false
    
    /**
     *  Indicates if the subroute is the first subroute to be drawn after pausing and resuming the activity. In that case, the subroute must not be visible
     */
    var firstSubrouteAfterPausingAndResumingActivity = false
    
    // - Test - //
    var testCounter = 0
    var testCounterRejected = 0
    
    func getMilesCounter() -> Double {
        return milesCounter
    }
    
    // MARK: - Methods -
    
    func resetActivity() {
        activity = Activity()
        milesCounter = 0.0
        
        startLatitude = 0.0
        startLongitude = 0.0
        endLatitude = 0.0
        endLongitude = 0.0
        
        poolId = ""
        
        lastLocation = CLLocation()
        lastSubrouteInitialLocation = CLLocation()
        
        subroutes = [MKPolyline]()
        mapIsMainScreen = false
        
        pausedAndResumedActivity = false
        firstSubrouteAfterPausingAndResumingActivity = false
    }
    
    static func setStartDateTime() {
        sharedInstance.startDateToTrack = NSDate()
    }
    
    static func getStartDateTime() -> String {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateUTC = formatter.stringFromDate(sharedInstance.startDateToTrack)
        return dateUTC
    }
    
    static func setMilesCounter(milesTravelled:Double) {
        sharedInstance.milesCounter += milesTravelled
    }
    
    static func updateMilesCounter(currentLocation:CLLocation) {
        let metersTravelled = sharedInstance.lastLocation.distanceFromLocation(currentLocation) as Double!
        setMilesCounter(metersTravelled*metersToMiles)
    }
    
    static func updateMilesCounterWithMeters(meters:Double) {
        setMilesCounter(meters*metersToMiles)
    }
    
    static func getMilesCounter() -> Double {
        return sharedInstance.milesCounter
    }
    
    static func getLastLocation() -> CLLocation {
        return sharedInstance.lastLocation
    }
    
    static func setLastLocation(lastLocation:CLLocation) {
        sharedInstance.lastLocation = lastLocation
    }
    
    static func getLastSubrouteInitialLocation() -> CLLocation {
        return sharedInstance.lastSubrouteInitialLocation
    }
    
    static func setLastSubrouteInitialLocation(lastLocation:CLLocation) {
        sharedInstance.lastSubrouteInitialLocation = lastLocation
    }
    
    static func getCircularProgressAngle() -> Double {
        return sharedInstance.milesCounter * 360
    }
    
    static func isMapMainScreen() -> Bool {
        return sharedInstance.mapIsMainScreen
    }
    
    static func setMapIsMainScreen(mapIsMainScreen:Bool) {
        sharedInstance.mapIsMainScreen = mapIsMainScreen
    }
    
    static func addSubroute(subroute:MKPolyline) {
        sharedInstance.subroutes.append(subroute)
    }
    
    static func getSubroutes() -> [MKPolyline] {
        return sharedInstance.subroutes
    }
    
    static func getActivityRouteString() -> String {
        
        let subroutes = sharedInstance.subroutes
        
        if subroutes.count == 0 {
            return ""
        }
        
        var activityRouteString = "["
        
        for polyline in subroutes {
            
            let lat = String(polyline.coordinate.latitude)
            let lon = String(polyline.coordinate.longitude)
            let invisible = polyline.title!
            activityRouteString = activityRouteString + "{'latitude':" + lat + ","
                + "'longitude':" + lon + ","
                + "'invisible':" + invisible + "},"
        }
        
        print("Activity Route:\n \(activityRouteString)")
        
        var finalString = activityRouteString.substringToIndex(activityRouteString.characters.count-1)
        finalString = finalString + "]"
        
        print("Activity Route Final:\n \(finalString)")
        
        return finalString
    }
    
    static func getActivityRouteJSON() -> [String:AnyObject] {
        
        let subroutes = sharedInstance.subroutes
        var jsonArrayRoute = [NSDictionary]()
        
        for polyline in subroutes {
            
            let lat = String(polyline.coordinate.latitude)
            let lon = String(polyline.coordinate.longitude)
            let invisible = String(polyline.title)
            
            let subroute = [
                "'latitude'":lat,
                "'longitude'":lon,
                "'invisible'":invisible
            ]
            
            jsonArrayRoute.append(subroute)
        }
        
        let activityRouteJSON = [
            "activity_route":jsonArrayRoute
        ]
        
        return activityRouteJSON
    }
    
    static func hasPausedAndResumedActivity() -> Bool {
        return sharedInstance.pausedAndResumedActivity
    }
    
    static func setPausedAndResumedActivity() {
        sharedInstance.pausedAndResumedActivity = true
    }
    
    static func isFirstSubrouteAfterPausingAndResumingActivity() -> Bool {
        return sharedInstance.firstSubrouteAfterPausingAndResumingActivity
    }
    
    static func setFirstSubrouteAfterPausingAndResumingActivity(value:Bool) {
        sharedInstance.firstSubrouteAfterPausingAndResumingActivity = value
    }
    
    // If the user has resumed the activity, we must not show the new subroute on the map
    static func subrouteShouldBeInvisible() -> Bool {
        if hasPausedAndResumedActivity() == true && isFirstSubrouteAfterPausingAndResumingActivity() == true {
            return true
        }
        
        return false
    }
    
    // - ActivityTestMethods - //
    static func getTestCounter() -> Int {
        return sharedInstance.testCounter
    }
    
    static func setTestCounter() {
        sharedInstance.testCounter += 1
    }
    
    static func getTestCounterRejected() -> Int {
        return sharedInstance.testCounterRejected
    }
    
    static func setTestCounterRejected() {
        sharedInstance.testCounterRejected += 1
    }
}
