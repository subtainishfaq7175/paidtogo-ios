//
//  ActivityManager.swift
//  Runz
//
//  Created by Osama Azmat Khan on 6/22/18.
//  Copyright © 2018 OZ Enterprises. All rights reserved.
//
import CoreLocation
import CoreMotion

enum ActivityTypeEnum {
    case none
    case walking
    case running
    case cycling
}

protocol ActivityMoniteringManagerDelegate {
    func didWalk(Steps steps: NSNumber, Distance distance:NSNumber)
    func didRun(Steps steps: NSNumber, Distance distance:NSNumber)
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
    
    var traveledDistance: Double = 0
    
    var speeds = Array<Double>()
    
    var motionType = ""
    
    // timers
    //var timer = Timer()
    let timerInterval = 1.0
    var timeElapsed:TimeInterval = 0.0
    
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if !ActivityON {
//            //viewControllerMain.checkMotion(<#ViewController#>)
//        }
//    }
    
    func checkMotion() {
        motionActivityManager.startActivityUpdates(to: OperationQueue.current!) { (activity) in
            
            if (activity?.running)! {
                self.trackRunning()
                self.motionType = "running"
                self.activityType = .running
            } else if (activity?.walking)! {
                self.trackWalking()
                self.motionType = "walking"
                self.activityType = .walking
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
    
    func trackWalking(){
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                //var distance = pedData.distance
                
                self.delegate?.didWalk(Steps: pedData.numberOfSteps, Distance: pedData.distance!)
                print("Steps:\(pedData.numberOfSteps) & Distance: \(pedData.distance)")
            } else {
                print("Steps: Not Available!")
            }
        })
    }
    
    func trackCycling(){
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                //var distance = pedData.distance
                print("Steps:\(pedData.numberOfSteps) & Distance: \(pedData.distance)")
            } else {
                print("Steps: Not Available!")
            }
        })
    }
    
   
    
    func trackRunning(){
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                //var distance = pedData.distance
                if self.delegate != nil {
                    self.delegate?.didRun(Steps: pedData.numberOfSteps, Distance: pedData.distance!)
                }
                print("Steps:\(pedData.numberOfSteps) & Distance: \(pedData.distance)")
            } else {
                print("Steps: Not Available!")
            }
        })
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
}

