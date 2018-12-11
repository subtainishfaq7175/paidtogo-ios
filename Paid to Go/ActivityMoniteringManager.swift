//
//  ActivityManager.swift
//  Paid To Go
//
//  Created by Razi Tiwana on 6/22/18.
//  Copyright © 2018 Ashler. All rights reserved.
//
import CoreLocation
import CoreMotion
//import HealthKit
import ObjectMapper

enum ActivityTypeEnum : Int , Codable {
    case none = 0
    case walkingRunning = 1
    case cycling = 3
    case workout = 2
}

protocol ActivityMoniteringManagerDelegate {
    func didWalk(Steps steps: NSNumber, Distance distance:Double)
    func didRun(Steps steps: NSNumber, Distance distance:Double)
    func didCycling(activity: ManualActivity)
    func didCycle(Speed speed: Double)
    func didCycle(Distance distance: Double)
    func didDetectActivity(Activity activity: CMMotionActivity)
}

protocol ActivityMoniteringMotionDelegate {
    func didDetectActivity(Activity activity: CMMotionActivity)
}

class ActivityMoniteringManager: NSObject, CLLocationManagerDelegate {
    
    var delegate: ActivityMoniteringManagerDelegate?
    
    var motionDelegate: ActivityMoniteringMotionDelegate?
    
    var activityType:ActivityTypeEnum = .none
    var locationManager : CLLocationManager?
    let pedometer = CMPedometer()
    let motionActivityManager = CMMotionActivityManager()

    var activityResponse: ActivityNotification?
    
    var startDate: Date!
    var autoTracking = true
    
     var autoTrackingWalking = false
     var autoTrackingCycling = false
    
     let userDefaults = UserDefaults.standard
    
    var isManualActivityDataPresent: Bool {
        get {
            return activityData.count > 0
        }
    }
//    var numberOfSteps:Int! = nil
//    var distance:Double! = nil
//    var averagePace:Double! = nil
//    var pace:Double! = nil
    
//    var sessionType = ""
    
    var calorieBurnt: Double = 0.0
    var distanceCovered = ""
    var avgSpeed = ""
    var seconds = 0
    var minutes = 0
    var timerCycling = Timer()
    var timerIsOn = false
    var firstSetUp = true
    var currentSpeed: Double = 0
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    
    var cyclingTimer: Timer = Timer()
    var autoTrackingActivityData: [ManualActivity] = []
    
    var autoTrackingActivityWalkingAndRunningData: ManualActivity?
    var autoTrackingActivityCyclingData: ManualActivity?
    
    var autoTrackingStartDate: Date {
        get {
            return Settings.shared.autoTrackingStartDate ?? Date()
        }
    }
    
    var autoTrackingStartDateForCycling: Date {
        get {
            return Settings.shared.autoTrackingStartDateForCycling ?? autoTrackingStartDate
        }
    }
    
    var manualTrackingStartDateForCycling: Date = Date()
    
    var traveledDistance: Double = 0
    
    var speeds = Array<Double>()
    
    var motionType = ""
    
    // timers
    //var timer = Timer()
    let timerInterval = 1.0
    var timeElapsed:TimeInterval = 0.0
    
    var activityData: [ManualActivity] = []
    
    var bikeActivityData: [ManualActivity] = []
    
    // These are the properties you can store in your singleton
    
    public var ActivityON: Bool = false
    var viewControllerMain = ViewController.self
    
    class var sharedManager: ActivityMoniteringManager {
        struct Static {
            static let instance = ActivityMoniteringManager()
        }
        return Static.instance
    }
    
    private override init() {
        
        if let activityData = userDefaults.value(forKey: "ActivityData") as? Data {
            do {
                let activities = try JSONDecoder().decode([ManualActivity].self, from: activityData)
                self.activityData = activities
            } catch {
                print(error)
            }
        }
        
        if let bikeActivityData = userDefaults.value(forKey: "BikeActivityData") as? Data {
            do {
                let activities = try JSONDecoder().decode([ManualActivity].self, from: bikeActivityData)
                self.bikeActivityData = activities
                
            } catch {
                print(error)
            }
        }
    }
    
    deinit {
        cyclingTimer.invalidate()
    }
    
    
    public func save(activity: ManualActivity) {
        activityData.append(activity)
        do {
            let data = try JSONEncoder().encode(activityData)
            userDefaults.set(data, forKey: "ActivityData")
        } catch {
            print(error)
        }
    }
    
    public func saveBike(activity: ManualActivity) {
        bikeActivityData.append(activity)
        do {
            let data = try JSONEncoder().encode(bikeActivityData)
            userDefaults.set(data, forKey: "BikeActivityData")
        } catch {
            print(error)
        }
    }
    
    public func removeLatestPossibleCyclingActivity() {
        
        // find the latest in the list
        bikeActivityData = bikeActivityData.reversed()
       
        var index = 0
        for bikeActivty in bikeActivityData {
            if bikeActivty.cyclingPossiblyDetected {
                bikeActivityData.remove(at: index)
            }
            index = index + 1
        }
        
        // Saving the array
        do {
            let data = try JSONEncoder().encode(bikeActivityData)
            userDefaults.set(data, forKey: "BikeActivityData")
        } catch {
            print(error)
        }
    }
    
//    func getData(for type: HKSampleType, unit: HKUnit, startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> Void) {
//
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
//
//        let newPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
//
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, newPredicate])
//
//        let query = HKSampleQuery(sampleType: type, predicate: compoundPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
//
//            var distance: Double = 0
//
//            if (results?.count)! > 0 {
//                for result in results as! [HKQuantitySample] {
//                    distance += result.quantity.doubleValue(for: unit)
//                }
//
//                if type.identifier == HKSampleType.quantityType(forIdentifier: .distanceCycling)?.identifier {
//                    // The iitem we get data for, the start date should be set to this, so that we don't lose
//                    if let lastItem = results?.last {
//                        Settings.shared.autoTrackingStartDateForCycling = lastItem.endDate
//                    }
//                }
//
//                completion(distance, nil)
//            } else {
//                completion(distance, error)
//            }
//        }
//
//        let healthStore = HKHealthStore()
//        healthStore.execute(query)
//    }
    
    func checkMotion() {
        motionActivityManager.startActivityUpdates(to: OperationQueue.current!) { (activity) in
            
            if self.delegate != nil, activity != nil {
                self.delegate?.didDetectActivity(Activity: activity!)
            }
            
            if self.motionDelegate != nil, activity != nil {
                self.motionDelegate?.didDetectActivity(Activity: activity!)
            }
        }
    }
    
    func stopTracking() {
        if #available(iOS 10.0, *) {
            pedometer.stopEventUpdates()
            cyclingTimer.invalidate()
        }
        motionActivityManager.stopActivityUpdates()
    }
    
    func trackWalking() {
        trackRunning(from: Date())
    }
    
    func trackRunning() {
        trackRunning(from: Date())
    }
    
    func trackRunning(from date:Date) {
        
        pedometer.startUpdates(from: date, withHandler: { (pedometerData, error) in
            if let pedData = pedometerData {
                if self.delegate != nil {
                    let distance = pedData.distance!.doubleValue * 0.00062137
                    self.delegate?.didWalk(Steps: pedData.numberOfSteps, Distance: distance)
                    self.delegate?.didRun(Steps: pedData.numberOfSteps, Distance: distance)
                }
                print("Steps:\(pedData.numberOfSteps) & Distance: \(pedData.distance)")
            } else {
                print("Steps: Not Available!")
            }
        })
    }
    
    func trackCycling() {
        cyclingTimer.invalidate()
        manualTrackingStartDateForCycling = Date()
        cyclingTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(getCycling), userInfo: nil, repeats: true)
    }
    
    @objc func getCycling() {
//        getCyclingData { [weak self] activity in
//            guard let strongSelf = self, let strongActivity = activity else {
//                return
//            }
//            if strongSelf.delegate != nil {
//                strongSelf.delegate?.didCycling(activity: strongActivity)
//            }
//        }
    }
    
//    func startCyclingTimer() {
//        if timerIsOn == false {
//            timerCycling = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
//            timerIsOn = true
//            self.locationManager?.startUpdatingLocation()
//            self.locationManager?.startMonitoringSignificantLocationChanges()
//            self.locationManager?.distanceFilter = 10
//            self.locationManager?.delegate = self
//        }
//    }
    
//    func stopTimer() {
//        self.startLocation = nil
//        //        traveledDistance = 0.0
//        var total: Double = 0.0
//        speeds.forEach { speed in
//            total += speed
//        }
//        var averageSpeed = total / Double(speeds.count)
//        averageSpeed = Double(averageSpeed * 1000).rounded()/1000
//        print("AverageSpeed: \(averageSpeed) Km/hrs")
//        print(averageSpeed)
//
//        //traveledDistance = Double(traveledDistance * 1000).rounded()/1000
//        traveledDistance = traveledDistance/1000
//        print("Distance: \(traveledDistance/1000) Kms")
//
//        self.calorieBurnt = (self.traveledDistance / 75.0) * 1.050
//        self.distanceCovered = "\(self.traveledDistance)"
//        self.avgSpeed = "avgSpeed: \(averageSpeed)"
//
//        timerCycling.invalidate()
//        seconds = 0
//        minutes = 0
//        timerIsOn = false
//        self.locationManager?.stopUpdatingLocation()
//    }
//
//    @objc func updateTimer() {
//        seconds += 1
//        if seconds == 60 {
//            minutes += 1
//            seconds = 0
//        }
//        //print("\(seconds)")
//    }
    
    func postDataAutomatically() {
        
        if Settings.shared.autoTrackingStartDate == nil {
            Settings.shared.autoTrackingStartDate = Date()
        }
        
        if Settings.shared.isAutoTrackingOn {
            // Auto data
            getHealthKitData()
        }
        
        // Sync activities for both the manual tracking and auto tracking
        // 
        syncManualActivities { (response, error) in
            NotificationCenter.default.post(name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_ACTIVITIES_SYNCED), object: nil)
        }
    }
    
    func saveAutoTackingDataforWalking() {
        if Settings.shared.isAutoTrackingOn {
            
            getWalkingRunningData { walkingRunningactivity in
                
                if let activity = walkingRunningactivity {
                    self.activityData.append(activity)
                }
            }
        }
    }
    
//    func postAutoTrackingData() {
//        // Sync when ever postAutoTrackingData is called
//        getHealthKitData()
//        
////        if let lastSyncDate = Settings.shared.autoTrackingStartDate {
////            let lastDateTimeStamp = lastSyncDate.timeIntervalSince1970
////            let currentTimeStamp = Date().timeIntervalSince1970
////            if currentTimeStamp - lastDateTimeStamp > 86400 {
////
////            }
////        }
//    }
    
    public func getHealthKitData() {
       
        getWalkingRunningData { walkingRunningactivity in
            
            if let activity = walkingRunningactivity {
                self.autoTrackingActivityWalkingAndRunningData = activity
            }
        
            self.autoTrackingWalking = true
            self.didGetHealthKitData()
        }
        
        self.autoTrackingCycling = true
        
//        getCyclingData { cyclingActivity in
//            if let activity = cyclingActivity {
//                self.autoTrackingActivityCyclingData = activity
//            }
//            self.autoTrackingCycling = true
//
//            self.didGetHealthKitData()
//        }
    }
    
    func didGetHealthKitData() {
        if autoTrackingWalking, autoTrackingCycling {
//            var jsonObject: [[String : Any]] = []
//            for activity in autoTrackingActivityData {
//                jsonObject.append(activity.toJSON())
//            }
            
            autoTrackingWalking = false
            autoTrackingCycling = false
            
            autoTrackingActivityData = []
            
            if let activity = autoTrackingActivityWalkingAndRunningData {
                if activity.milesTraveled != 0 {
                 autoTrackingActivityData.append(activity)
                }
            }
            
//            if let activity = autoTrackingActivityCyclingData {
//                if activity.milesTraveled != 0 {
//                    autoTrackingActivityData.append(activity)
//                }
//            }
          
            autoTrackingActivityData.append(contentsOf: bikeActivityData)
            
            if autoTrackingActivityData.count > 0 {
                DataProvider.sharedInstance.registerActivites(getJSONArray(fromActivities: autoTrackingActivityData) as [AnyObject]) { (response, error) in
                    
                    if error == nil {
                        self.autoTrackingActivityData = []
                        Settings.shared.autoTrackingStartDate = Date()
                        
                        if let activityData :ActivityNotification = Mapper<ActivityNotification>().map(JSON:response as! [String : Any]) {
                            if let activity = self.autoTrackingActivityWalkingAndRunningData {
                                activityData.totalSteps = activity.steps
                            }
                            self.activityResponse = activityData
                        }
                        
                        self.userDefaults.set(nil, forKey: "BikeActivityData")
                        self.bikeActivityData = []
                        
                    } else {
                         self.activityResponse = nil
                    }
                    
                    // Post notification
                    NotificationCenter.default.post(name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_ACTIVITIES_SYNCED), object: nil)
                    
                }
            } else {
                self.activityResponse = nil
                // Post notification
                NotificationCenter.default.post(name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_ACTIVITIES_SYNCED), object: nil)
                
            }
        }
    }
    
    private func getWalkingRunningData(completion: @escaping (ManualActivity?) -> Void) {
        let autoActivity = ManualActivity()
        
//        guard let distanceType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
//            return
//        }
//        let distanceUnit = HKUnit.mile()
        let startDate = autoTrackingStartDate
        let endDate = Date()
        
        
        // We have to get the Data up till now in case of Auto tracking and the user is currently stationary
        pedometer.queryPedometerData(from: startDate, to: endDate) { (pedometerData, error) in
            if let pedData = pedometerData {
                    let distance = pedData.distance!.doubleValue * 0.00062137
                    let steps = pedData.numberOfSteps
                    
                    autoActivity.milesTraveled = distance
                    autoActivity.steps = steps.intValue
                    autoActivity.startDate = startDate
                    autoActivity.endDate = endDate
                    autoActivity.type = .walkingRunning
                    
                    autoActivity.startLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
                    autoActivity.startLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
                    
                    autoActivity.endLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
                    autoActivity.endLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
                 
                    completion(autoActivity)
                print("Steps:\(pedData.numberOfSteps) & Distance: \(pedData.distance)")
            } else {
                completion(nil)
                print("Steps: Not Available!")
            }
        }
        
//        getData(for: distanceType, unit: distanceUnit, startDate: startDate, endDate: endDate) { [weak self] distance, error in
//            if (error != nil) {
//                completion(nil)
//                print(error)
//            } else {
//                autoActivity.milesTraveled = distance
//                autoActivity.startDate = startDate
//                autoActivity.endDate = endDate
//                autoActivity.type = .walkingRunning
//
//                autoActivity.startLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
//                autoActivity.startLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
//
//                autoActivity.endLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
//                autoActivity.endLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
//
//                print(autoActivity)
//
//                guard let stepType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
//                    return
//                }
//
//                let stepUnit = HKUnit.count()
//
//                guard let strongSelf = self else {
//                    return
//                }
//                strongSelf.getData(for: stepType, unit: stepUnit, startDate: startDate, endDate: endDate) { steps, error in
//                    if (error != nil) {
//                        print(error)
//                        completion(nil)
//                    } else {
//                        autoActivity.steps = Int(steps)
//                        print(autoActivity)
//                        completion(autoActivity)
//                    }
//                }
//            }
//        }
    }
    
//    private func getCyclingData(completion: @escaping (ManualActivity?) -> Void) {
//        let autoActivity = ManualActivity()
//        
//        guard let distanceType = HKSampleType.quantityType(forIdentifier: .distanceCycling) else {
//            return
//        }
//        
//        let distanceUnit = HKUnit.mile()
//        var startDate = autoTrackingStartDateForCycling
//        
//        if !Settings.shared.isAutoTrackingOn {
//            startDate = manualTrackingStartDateForCycling
//        }
//        
//        let endDate = Date()
//        
//        getData(for: distanceType, unit: distanceUnit, startDate: startDate, endDate: endDate) { distance, error in
//            if (error != nil) {
//                completion(nil)
//                print(error ?? "error")
//            } else {
//                autoActivity.milesTraveled = distance
//                autoActivity.startDate = startDate
//                autoActivity.endDate = endDate
//                autoActivity.type = .cycling
//                
//                autoActivity.startLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
//                autoActivity.startLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
//                
//                autoActivity.endLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
//                autoActivity.endLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
//                
//                print(autoActivity)
//                completion(autoActivity)
//            }
//        }
//    }
    
    func getJSONArray(fromActivities activities:[ManualActivity]) -> [[String : Any]] {
        var jsonArray: [[String : Any]] = []
        for activity in activities {
            jsonArray.append(activity.toJSON())
        }
        return jsonArray
    }
    
    func syncManualActivities(completion: @escaping (_ respose: AnyObject?, _ error: String?) -> Void)  {
        
        if activityData.count > 0 {
            DataProvider.sharedInstance.registerActivites(getJSONArray(fromActivities: activityData) as [AnyObject]) { (response, error) in
                completion(response , error)
                
                if error == nil {
                    self.userDefaults.set(nil, forKey: "ActivityData")
                    self.activityData = []
                }
            }
        } else {
            completion(nil , nil)
        }
    }
}
