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

protocol ActivityTest {
    
    var testCounter : Int { get set }
    var testCounterRejected : Int { get set }
    
    static func getTestCounter() -> Int
    static func setTestCounter()
    static func getTestCounterRejected() -> Int
    static func setTestCounterRejected()
}

/* 
 *  Handles the whole activity process, and the necessary information to update the progress circle
 */
class ActivityManager: NSObject, ActivityTest {
    
    /**
     *  Singleton
     *
     *  We use a Singleton to allow a quick switch between the different Pool Types (Walk/Run, Bike and Bus/Train)
     *
     */
    static let sharedInstance = ActivityManager()
    
    private override init() {
        
    }
    
    // - Test - //
    var testCounter = 0
    var testCounterRejected = 0
    
    internal static let metersToMiles = 0.000621371
    
    var activity : Activity = Activity()
    
    var poolId : String = ""
    
    var startDateToTrack : NSDate = NSDate()
    
    var milesCounter : Double = 0.0
    var endLatitude: Double = 0.0
    var endLongitude: Double = 0.0
    
    var startLatitude : Double = 0.0
    var startLongitude : Double = 0.0
    
    var initialLocation : CLLocation = CLLocation()
    
    
//    var metersFromStartLocation : Double = 0.0
//    var distanceToFinalDestination : Double = 0.0
    
    //--//
    var lastLocation : CLLocation = CLLocation()
    var lastSubrouteInitialLocation : CLLocation = CLLocation()
    
    var subroutes = [MKPolyline]()
    var subroutesPosta = [Subroute]()
    var mapIsMainScreen : Bool = false
    
    /**
     *  Indicates if the pool has been paused at least once
     */
    var pausedAndResumedActivity = false
    
    /**
     *  Indicates if the subroute is the first subroute to be drawn after pausing and resuming the activity. In that case, the subroute must not be visible
     */
    var firstSubrouteAfterPausingAndResumingActivity = false
    
    func getMilesCounter() -> Double {
        return milesCounter
    }
    
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
        subroutesPosta = [Subroute]()
        mapIsMainScreen = false
        
        pausedAndResumedActivity = false
        firstSubrouteAfterPausingAndResumingActivity = false
    }
    
    //--//
    
//    static func getTrackNumber() -> Double {
//        return sharedInstance.trackNumber
//    }
    
    static func setStartDateTime() {
        sharedInstance.startDateToTrack = NSDate()
    }
    
    static func getStartDateTime() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(sharedInstance.startDateToTrack)
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
    
    static func getSubroutesPosta() -> [Subroute] {
        return sharedInstance.subroutesPosta
    }
    
    static func addSubroutePosta(subroute:Subroute) {
        sharedInstance.subroutesPosta.append(subroute)
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
