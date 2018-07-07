//
//  ActivityManager.swift
//  Runz
//
//  Created by Osama Azmat Khan on 6/22/18.
//  Copyright © 2018 OZ Enterprises. All rights reserved.
//
import CoreLocation
import CoreMotion
import HealthKit

enum ActivityTypeEnum : Int {
    case none
    case walkingRunning
    case cycling
}

protocol ActivityMoniteringManagerDelegate {
    func didWalk(Steps steps: NSNumber, Distance distance:Double)
    func didRun(Steps steps: NSNumber, Distance distance:Double)
    func didCycling(activity: ManualActivity)
    func didCycle(Speed speed: Double)
    func didCycle(Distance distance: Double)
    func didDetectActivity(Activity activity: NSString)
}

class ActivityMoniteringManager: NSObject, CLLocationManagerDelegate {
    
    var delegate:ActivityMoniteringManagerDelegate?
    
    var activityType:ActivityTypeEnum = .none
    var locationManager : CLLocationManager?
    let pedometer = CMPedometer()
    let motionActivityManager = CMMotionActivityManager()

    var startDate: Date!
    var autoTracking = true
    
     var autoTrackingWalking = false
     var autoTrackingCycling = false
    
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
    
    var autoTrackingStartDate: Date {
        get {
            return Settings.shared.autoTrackingStartDate ?? Date()
        }
    }
    
    var traveledDistance: Double = 0
    
    var speeds = Array<Double>()
    
    var motionType = ""
    
    // timers
    //var timer = Timer()
    let timerInterval = 1.0
    var timeElapsed:TimeInterval = 0.0
    
    var activityData: [ManualActivity] = []
    
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
        let userDefaults = UserDefaults.standard
        if let activityData = userDefaults.value(forKey: "ActivityData") as? Data {
            do {
                let activities = try JSONDecoder().decode([ManualActivity].self, from: activityData)
                self.activityData = activities
            } catch {
                print(error)
            }
        }
    }
    
    deinit {
        cyclingTimer.invalidate()
    }
    
    func initLocationManager()  {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        //locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
    }
    
    func locationLister() {
        self.initLocationManager()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //startTimer(self)
        
        if activityType == .cycling {
            
            //self.isCycling = true
            
            if startDate == nil {
                startDate = Date()
            }
            else {
                print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
            }
            if startLocation == nil {
                startLocation = locations.first
            }
            else if let location = locations.last {
                traveledDistance += lastLocation.distance(from: location)
                //            print("Traveled Distance:",  traveledDistance)
                //            print("Straight Distance:", startLocation.distance(from: locations.last!))
                
                //traveledDistance = Double(traveledDistance * 1000).rounded()/1000
                //traveledDistance = traveledDistance/1000
                print("Distance: \(traveledDistance/1609.344) miles")
                
            }
            
            lastLocation = locations.last
            
            currentSpeed = lastLocation.speed
            currentSpeed = Double(currentSpeed * 1609.344).rounded()/1609.344
            currentSpeed = currentSpeed * (60*60)/1609.344
            speeds.append(currentSpeed)
            
            var total: Double = 0.0
            
            speeds.forEach { speed in
                total += speed
            }
            
            var averageSpeed = total / Double(speeds.count)
            averageSpeed = Double(averageSpeed * 1609.344).rounded()/1609.344
            print("AverageSpeed: \(averageSpeed) miles")
            self.delegate?.didCycle(Speed: averageSpeed)
            self.delegate?.didCycle(Distance: traveledDistance/1609.344)
            
            if speeds.count > 10 {
                if averageSpeed <= 5 {
                    self.stopTimer()
                }
            }
        }
    }
    
    public func save(activity: ManualActivity) {
        activityData.append(activity)
        let userDefaults = UserDefaults.standard
        do {
            let data = try JSONEncoder().encode(activityData)
            userDefaults.set(data, forKey: "ActivityData")
        } catch {
            print(error)
        }
    }
    
    func getData(for type: HKSampleType, unit: HKUnit, startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> Void) {
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            
            var distance: Double = 0
            
            if (results?.count)! > 0 {
                for result in results as! [HKQuantitySample] {
                    distance += result.quantity.doubleValue(for: unit)
                }
                completion(distance, nil)
            } else {
                completion(distance, error)
            }
        }
        
        let healthStore = HKHealthStore()
        healthStore.execute(query)
    }
    
    func checkMotion() {
        motionActivityManager.startActivityUpdates(to: OperationQueue.current!) { (activity) in
            
            if (activity?.running)! {
                self.trackRunning()
                self.motionType = "running"
                self.activityType = .walkingRunning
            } else if (activity?.walking)! {
                self.trackWalking()
                self.motionType = "walking"
                self.activityType = .walkingRunning
            } else if (activity?.cycling)! {
                self.startCyclingTimer()
                self.motionType = "cycling"
                self.activityType = .cycling
            } else {
                self.activityType = .none
            }
            
            if self.delegate != nil {
                self.delegate?.didDetectActivity(Activity: self.motionType as NSString)
            }
        }
    }
    
    func stopTracking() {
        if #available(iOS 10.0, *) {
            pedometer.stopEventUpdates()
            cyclingTimer.invalidate()
        }
    }
    
    func trackWalking(){
        trackRunning(fromDate: Date())
    }
    
    func trackRunning(){
       trackRunning(fromDate: Date())
    }
    
    func trackRunning(fromDate date:Date) {
        
        // To get the Data uptill now for auto tracking
        pedometer.queryPedometerData(from: date, to: Date()) { (pedometerData, error) in
            if let pedData = pedometerData {
                if self.delegate != nil {
                    let distance = pedData.distance!.doubleValue * 0.00062137
                    self.delegate?.didRun(Steps: pedData.numberOfSteps, Distance: distance)
                }
                print("Steps:\(pedData.numberOfSteps) & Distance: \(pedData.distance)")
            } else {
                print("Steps: Not Available!")
            }
        }
        
        pedometer.startUpdates(from: date, withHandler: { (pedometerData, error) in
            if let pedData = pedometerData {
                if self.delegate != nil {
                    let distance = pedData.distance!.doubleValue * 0.00062137
                    self.delegate?.didRun(Steps: pedData.numberOfSteps, Distance: distance)
                }
                print("Steps:\(pedData.numberOfSteps) & Distance: \(pedData.distance)")
            } else {
                print("Steps: Not Available!")
            }
        })
    }
    
    
    
    func trackCycling(){
        cyclingTimer.invalidate()
        cyclingTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(getCycling), userInfo: nil, repeats: true)
    }
    
    @objc func getCycling() {
        getCyclingData { [weak self] activity in
            guard let strongSelf = self, let strongActivity = activity else {
                return
            }
            if strongSelf.delegate != nil {
                strongSelf.delegate?.didCycling(activity: strongActivity)
            }
        }
    }
    
    func startCyclingTimer() {
        if timerIsOn == false {
            timerCycling = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            timerIsOn = true
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.startMonitoringSignificantLocationChanges()
            self.locationManager?.distanceFilter = 10
            self.locationManager?.delegate = self
        }
    }
    
    func stopTimer() {
        self.startLocation = nil
        //        traveledDistance = 0.0
        var total: Double = 0.0
        speeds.forEach { speed in
            total += speed
        }
        var averageSpeed = total / Double(speeds.count)
        averageSpeed = Double(averageSpeed * 1000).rounded()/1000
        print("AverageSpeed: \(averageSpeed) Km/hrs")
        print(averageSpeed)
        
        //traveledDistance = Double(traveledDistance * 1000).rounded()/1000
        traveledDistance = traveledDistance/1000
        print("Distance: \(traveledDistance/1000) Kms")
        
        self.calorieBurnt = (self.traveledDistance / 75.0) * 1.050
        self.distanceCovered = "\(self.traveledDistance)"
        self.avgSpeed = "avgSpeed: \(averageSpeed)"
        
        timerCycling.invalidate()
        seconds = 0
        minutes = 0
        timerIsOn = false
        self.locationManager?.stopUpdatingLocation()
    }
    
    @objc func updateTimer() {
        seconds += 1
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        //print("\(seconds)")
    }
    
    func postDataAutomatically() {
        getHealthKitData()
    }
    
    func postAutoTrackingData() {
        getHealthKitData()
    }
    
    private func getHealthKitData() {
        var activities: [ManualActivity] = []
        getWalkingRunningData { walkingRunningactivity in
            if let activity = walkingRunningactivity {
                activities.append(activity)
            }
            self.autoTrackingWalking = true
            self.autoTrackingActivityData = activities
            self.didGetHealthKitData()
        }
        
        getCyclingData { cyclingActivity in
            if let activity = cyclingActivity {
                activities.append(activity)
            }
            self.autoTrackingCycling = true
            self.autoTrackingActivityData = activities
            self.didGetHealthKitData()
        }
    }
    
    func didGetHealthKitData() {
        if autoTrackingWalking, autoTrackingCycling {
            var jsonObject: [[String : Any]] = []
            for activity in autoTrackingActivityData {
                jsonObject.append(activity.toJSON())
            }
            
            do {
                if JSONSerialization.isValidJSONObject(jsonObject) {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func getWalkingRunningData(completion: @escaping (ManualActivity?) -> Void) {
        let autoActivity = ManualActivity()
        
        guard let distanceType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        let distanceUnit = HKUnit.mile()
        let startDate = autoTrackingStartDate
        let endDate = Date()
        
        getData(for: distanceType, unit: distanceUnit, startDate: startDate, endDate: endDate) { [weak self] distance, error in
            if (error != nil) {
                completion(nil)
                print(error)
            } else {
                autoActivity.milesTraveled = distance
                autoActivity.startDate = startDate
                autoActivity.endDate = endDate
                autoActivity.type = .walkingRunning
                print(autoActivity)
                
                guard let stepType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
                    return
                }
                let stepUnit = HKUnit.count()
                
                guard let strongSelf = self else {
                    return
                }
                strongSelf.getData(for: stepType, unit: stepUnit, startDate: startDate, endDate: endDate) { steps, error in
                    if (error != nil) {
                        print(error)
                        completion(nil)
                    } else {
                        autoActivity.steps = Int(steps)
                        print(autoActivity)
                        completion(autoActivity)
                    }
                }
            }
        }
    }
    
    private func getCyclingData(completion: @escaping (ManualActivity?) -> Void) {
        let autoActivity = ManualActivity()
        
        guard let distanceType = HKSampleType.quantityType(forIdentifier: .distanceCycling) else {
            return
        }
        let distanceUnit = HKUnit.mile()
        let startDate = autoTrackingStartDate
        let endDate = Date()
        
        getData(for: distanceType, unit: distanceUnit, startDate: startDate, endDate: endDate) { distance, error in
            if (error != nil) {
                completion(nil)
                print(error)
            } else {
                autoActivity.milesTraveled = distance
                autoActivity.startDate = startDate
                autoActivity.endDate = endDate
                autoActivity.type = .cycling
                print(autoActivity)
                completion(autoActivity)
            }
        }
    }
}

