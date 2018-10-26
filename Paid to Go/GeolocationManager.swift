
//
//  GeolocationManager.swift
//  Paid to Go
//
//  Created by Nahuel on 18/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

import CoreLocation
import UserNotifications
import CoreMotion

let k20MeterDistance = 20

class GeolocationManager: NSObject {
    //    Singalton Implementations
    static let sharedInstance = GeolocationManager()
    
    var locationManager = CLLocationManager()
    private var currentLocation = CLLocation()
    var gymLocations:[GymLocation] = []
    var currentGymLocation:GymLocation?
    
    let userDefaults = UserDefaults.standard
    
    
    // For bike Detection
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    
    var startDate: Date?
    var traveledDistance: Double = 0
    
    var cyclingDetected = false
    
    var cyclingSelectedFromManual = false
    
    var nonCyclingActivitesCount = 0
    var cyclingFixedTimePassed = false
    
    var cyclingTimer: Timer = Timer()
    
    private override init() {
        super.init()
        fetchLocations()
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 1
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        ActivityMoniteringManager.sharedManager.motionDelegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse,.authorizedAlways:
            break
        default:
            print(Constants.consShared.APP_NAME,"app not authorized for loacation")
            break
        }
        
        
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func pauseLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func stopMoneteringRegions() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func getCurrentLocation() -> CLLocation {
        
        if self.currentLocation.coordinate.latitude == 0 && self.currentLocation.coordinate.longitude == 0 {
             let currentLocation = CLLocation(latitude: getCurrentLocationCoordinate().latitude, longitude: getCurrentLocationCoordinate().longitude)
            return currentLocation
        }
        
        // if not than we need the speed valuers and other things with this location
        return self.currentLocation
    }
    
    func getCurrentLocationCoordinate() -> CLLocationCoordinate2D {
        var currentLoaction = self.currentLocation.coordinate
        
        if currentLoaction.latitude == 0 && currentLoaction.longitude == 0 {
            currentLoaction.latitude = userDefaults.double(forKey: "currentLoaction.latitude")
            currentLoaction.longitude = userDefaults.double(forKey: "currentLoaction.longitude")
        }
        
        return currentLoaction
    }
    
    private func fetchLocations() {
        if let locationsData = userDefaults.value(forKey: "gymlocation") as? Data {
            do {
                let locations = try JSONDecoder().decode([GymLocation].self, from: locationsData)
                self.gymLocations = locations
                
                print(self.gymLocations)
            } catch {
                print(error)
            }
        }
    }
    
    private func saveGymLocations() {
        do {
            let data = try JSONEncoder().encode(gymLocations)
            userDefaults.set(data, forKey: "gymlocation")
        } catch {
            print(error)
        }
    }
    
    func clearSavedLocation() {
        userDefaults.set(nil, forKey: "gymlocation")
    }
    
    public func add(gymlocation: GymLocation) {
        gymLocations.append(gymlocation)
        startMoniteringGymLocation(gymlocation: gymlocation)
        
        saveGymLocations()
    }
    
    public func removeGymlocation(withIdentifier identifier: String) {
        var gymIndex = -1
        for index in 0..<gymLocations.count {
            if gymLocations[index].identifier == identifier {
                gymIndex = index
                break;
            }
        }
        if gymIndex >= 0 {
            stopMoniteringGymLocation(gymlocation: gymLocations[gymIndex])
            gymLocations.remove(at: gymIndex)
            
            saveGymLocations()
            // now remove the exit one
            removeGymlocation(withIdentifier: identifier + "exit")
        }
    }
    
    public func checkInCurrentGym() {
        if let currentGymLocation = currentGymLocation {
            currentGymLocation.checkinDate = Date()
            currentGymLocation.timesCheckIns = (currentGymLocation.timesCheckIns ?? 0) + 1
            saveGymLocations()
        }
    }
    
    public func checkOutCurrentGym() {
        if let currentGymLocation = currentGymLocation {
            currentGymLocation.checkinDate = nil
            currentGymLocation.lastCheckInDate = Date()
            saveGymLocations()
        }
    }
    
    private func startMoniteringGymLocation(gymlocation: GymLocation) {
        // for entry using a 20 meter reagion
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(gymlocation.lattitude!, gymlocation.longitude!), radius: k20MeterDistance.toDouble, identifier: gymlocation.identifier!)
        
        // for exit using a 40 meter region
        // If the user enters the 20 meter regin he needs
        let geoFenceRegionexit:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(gymlocation.lattitude!, gymlocation.longitude!), radius: k20MeterDistance.toDouble, identifier: gymlocation.identifier! + "exit")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        locationManager.startMonitoring(for: geoFenceRegionexit)
    }
    
   private func stopMoniteringGymLocation(gymlocation: GymLocation) {
        var geoFenceRegion:CLRegion?
        
        for region in locationManager.monitoredRegions {
            if region.identifier == gymlocation.identifier {
                geoFenceRegion = region
                break;
            }
        }
        
        if let geoFenceRegion = geoFenceRegion {
            locationManager.stopMonitoring(for: geoFenceRegion)
        }
    }
    
    func registerForNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if error != nil {
                print("Request authorization failed!")
            } else {
                print("Request authorization succeeded!")
            }
        }
    }
    
    func postLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Gym Check-In", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Open app and checkin to " + (currentGymLocation?.name)!, arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = (currentGymLocation?.identifier)!
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest.init(identifier: (currentGymLocation?.identifier)!, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    private func autoTrackingBikelocationUpdated() {
        let currentLocation = GeolocationManager.sharedInstance.getCurrentLocation()
        
        // Ask for request
        ActivityMoniteringManager.sharedManager.checkMotion()
        
        if  ActivityMoniteringManager.sharedManager.motionDelegate  == nil {
            ActivityMoniteringManager.sharedManager.motionDelegate = self
        }
        
        // if cycling detected
        if cyclingDetected {
            let speed = currentLocation.speed * 2.23694
            
            if startDate == nil {
               startCyclingActivity()
            } else {
                print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate!)))
            }
            
            if lastLocation != nil {
                let location = currentLocation
                traveledDistance += lastLocation.distance(from: location)
                print("Traveled Distance:",  traveledDistance)
            }
            
            lastLocation = currentLocation
            
            if (speed) > Double(5 + (MasterData.sharedData?.speedOnBike)! ) {
                endCyclingActivity()
            }
        }
    }
    
    func startCyclingActivity() {
        cyclingDetected = true
        startDate = Date()
        startLocation = GeolocationManager.sharedInstance.getCurrentLocation()
    }
    
    func endCyclingActivity() {
        cyclingDetected = false
        
        let newBikingActivity = ManualActivity()
        newBikingActivity.type = .cycling
        
        newBikingActivity.startLat = startLocation.coordinate.latitude
        newBikingActivity.startLong = startLocation.coordinate.longitude
        
        newBikingActivity.endLat = currentLocation.coordinate.latitude
        newBikingActivity.endLong = currentLocation.coordinate.longitude
        
        newBikingActivity.milesTraveled = traveledDistance * 0.000621371
        
        newBikingActivity.startDate = startDate
        newBikingActivity.endDate = Date()
        
        ActivityMoniteringManager.sharedManager.saveBike(activity: newBikingActivity)
        
        startDate = nil
        traveledDistance = 0
        lastLocation = nil
    }
}

extension GeolocationManager : ActivityMoniteringMotionDelegate {
    
    func didDetectActivity(Activity activity: CMMotionActivity) {
        
        // confidence -> high, medium, low
        if activity.cycling {
            nonCyclingActivitesCount = 0
            cyclingDetected = true
            cyclingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
        
        if activity.confidence == .high {
            if !activity.cycling, !activity.stationary {
                notCyclingDetected()
            }
        }
    }
    
    func notCyclingDetected() {
        if cyclingFixedTimePassed {
            cyclingFixedTimePassed = false
            nonCyclingActivitesCount = nonCyclingActivitesCount + 1
            
            if nonCyclingActivitesCount > 4 {
                cyclingDetected = false
                cyclingTimer.invalidate()
                endCyclingActivity()
            }
        }
    }
    
    @objc private func updateTimer() {
        cyclingFixedTimePassed = true
    }
}

extension GeolocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            startLocationUpdates()
        } else {
            print("User didn't authorize the app to use the current location.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        // In case the app was suspended and launched from significant location changed
        locationManager.startUpdatingLocation()
        
        // Save coordinates in userDefaults
        userDefaults.set(locationObj.coordinate.latitude, forKey: "currentLoaction.latitude")
        userDefaults.set(locationObj.coordinate.longitude, forKey: "currentLoaction.longitude")
        
        currentLocation = locationObj
        
        autoTrackingBikelocationUpdated()
        NotificationCenter.default.post(name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_LOCATION_UPDATED), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        for gymlocation in gymLocations {
            if region.identifier == gymlocation.identifier {
                currentGymLocation = gymlocation
                
                saveGymLocations()
                
                // Post notification
                NotificationCenter.default.post(name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_DID_ENTER_CURRENT_GYM), object: nil)
                
                // Post local notification
                postLocalNotification()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if let currentGymLocation = currentGymLocation {
            if region.identifier == currentGymLocation.identifier! + "exit" {
                checkOutCurrentGym()
                self.currentGymLocation = nil
                
                // Post notification
                NotificationCenter.default.post(name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_DID_EXIT_CURRENT_GYM), object: nil)
            }
        }
    }
}
