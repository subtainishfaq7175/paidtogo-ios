//
//  PoolViewController+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 27/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import KDCircularProgress
import Foundation
import CoreLocation
import CoreMotion
import AVFoundation

extension PoolViewController {
    
    // MARK: -  View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initButtons()
        initLocationManager()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if(screenSize.height == 480.0) { //iPhone 4S
            self.circularProgressCenterYConstraint.constant = 0
        }
        
        if type == .Walk && CMPedometer.isStepCountingAvailable() {
            self.stepCountLabel.hidden = false
        } else {
            self.stepCountLabel.hidden = true
        }
        
        if type == PoolTypeEnum.Walk || type == PoolTypeEnum.Bike {
            circularProgressRoundOffset = 1.0
        } else {
            circularProgressRoundOffset = 10.0
        }
        
        let angle = ActivityManager.getCircularProgressAngle()
        self.circularProgressView.angle = angle / circularProgressRoundOffset
        
        let milesCounter = ActivityManager.sharedInstance.getMilesCounter()
        self.progressLabel.text = String(format: "%.2f", milesCounter)
    }
    
    // MARK: - Private Methods
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        setBorderToView(bannerImageView, color: CustomColors.NavbarTintColor().CGColor)
        bannerImageView.yy_setImageWithURL(NSURL(string: (pool?.banner)!), options: .ShowNetworkActivity)
        
        setPoolTitle(self.type!)
        setPoolBackgroundImage(self.type!)
        
        if type != PoolTypeEnum.Car {
            
            let switchImage = UIImage(named: "ic_pool_switch")
            let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: switchImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PoolViewController.switchButtonPressed))
            self.navigationItem.rightBarButtonItem = rightButtonItem
        }
        
        if hasPausedAndResumedActivity {
//            print("PAUSE BUTTON ON")
            pauseButton.hidden = false
        } else {
//            print("PAUSE BUTTON OFF")
            pauseButton.hidden = true
        }
    }
    
    private func initViews() {
        actionButtonView.round()
    }
    
    private func initButtons() {
        actionButton.addTarget(self, action: #selector(PoolViewController.actionButtonPressed), forControlEvents: .TouchUpInside)
        pauseButton.addTarget(self, action: #selector(PoolViewController.pauseResumeButtonPressed), forControlEvents: .TouchUpInside)
        mapButton.addTarget(self, action: #selector(PoolViewController.mapButtonPressed), forControlEvents: .TouchUpInside)
    }
    
//    func initLocationManager() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        
//        locationManager.requestAlwaysAuthorization()
//    }
    
    private func setPoolBackgroundImage(type: PoolTypeEnum) {
        switch type {
        case .Walk:
            let titleImage = UIImage(named: kWalkBackgroundImage)
            self.backgroundImageView.image = titleImage
            break
        case .Bike:
            let titleImage = UIImage(named: kRunBackgroundImage)
            self.backgroundImageView.image = titleImage
            break
        case .Train:
            let titleImage = UIImage(named: kTrainBackgroundImage)
            self.backgroundImageView.image = titleImage
            break
        default:
            let titleImage = UIImage(named: kCarPoolBackgroundImage)
            self.backgroundImageView.image = titleImage
            break
        }
    }
    
    // MARK: - IBActions
    
    func actionButtonPressed() {
        
        if !hasPoolStarted {
            
            activity = Activity()
            
            self.startDateToTrack = NSDate()
            
            hasPoolStarted = true
            
            actionButton.setTitle("action_finish".localize(), forState: UIControlState.Normal)
            setPoolColor(self.actionButtonView, type: self.type!)
            
            startTracking()
            
            pauseButton.hidden = false
            
            startLocationUpdates()
            
        } else {
            
            countingSteps = false
            endTracking()
            
        }
    }
    
    func pauseResumeButtonPressed() {
        pauseResumeTracking()
    }
    
    func mapButtonPressed() {
        self.performSegueWithIdentifier(kMapSegueIdentifier, sender: nil)
    }
    
    func switchButtonPressed() {
        self.pauseTracking()
        self.showPoolSwitchAlert("Switch Pool")
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        case "wellDoneSegue":
            let wellDoneNavigationController = segue.destinationViewController as! UINavigationController
            let wellDoneViewController = wellDoneNavigationController.viewControllers.first as! WellDoneViewController
            
            wellDoneViewController.type = self.type
            break
        default:
            let mapViewController = segue.destinationViewController as! MapViewController
            mapViewController.locationManager = self.locationManager
            mapViewController.locationCoordinate = self.locationManager.location?.coordinate
            ActivityManager.setMapIsMainScreen(true)
            self.mapViewController = mapViewController
            break
        }
    }
}

// MARK: - TrackDelegate

extension PoolViewController: TrackDelegate {
    
    func startTracking() {
        
        hasPausedAndResumedActivity = true
        
        pauseButton.setTitle("Pause", forState: UIControlState.Normal)
        isTimerTracking = true
        countingSteps = true
        
//        updatePedometer()
    }
    
    func pauseTracking() {
        pauseButton.setTitle("Resume", forState: UIControlState.Normal)
        isTimerTracking = false
        countingSteps = false
    }
    
    func pauseResumeTracking() {
        // Paused
        if isTimerTracking {
            
//            pausePedometerUpdates()
            pauseTracking()
            pauseLocationUpdates()
            
        // Resumed
        } else {
            
//            resumePedometerUpdates()
            startTracking()
            startLocationUpdates()
        }
    }
    
    func endTracking() {
        
        print(activity.startLatitude)
        print(activity.startLongitude)
        print(activity.endLatitude)
        print(activity.endLongitude)
        
        activity.startLatitude = ActivityManager.sharedInstance.startLatitude
        activity.startLongitude = ActivityManager.sharedInstance.startLongitude
        activity.endLatitude = ActivityManager.sharedInstance.endLatitude
        activity.endLongitude = ActivityManager.sharedInstance.endLongitude
        
        activity.milesTraveled = String(format: "%.2f", ActivityManager.getMilesCounter()) //self.milesTraveled
        activity.startDateTime = String(ActivityManager.sharedInstance.startDateToTrack) //String(self.startDateToTrack)
        activity.poolId = ActivityManager.sharedInstance.poolId //pool?.internalIdentifier
        activity.accessToken = User.currentUser?.accessToken
        
        print(activity.toString())
        
        self.locationManager.stopUpdatingLocation()
        self.pedoMeter.stopPedometerUpdates()
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.postRegisterActivity(self.activity) { (activityResponse, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                return
            }
            
            if let response = activityResponse {
                
                let poolDoneNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("poolDoneNavigationController") as! UINavigationController
                let wellDoneViewController = poolDoneNavigationController.viewControllers[0] as! WellDoneViewController
                
                wellDoneViewController.type = self.type
                wellDoneViewController.poolType = self.poolType
                wellDoneViewController.activityResponse = response
                wellDoneViewController.activity = self.activity
                wellDoneViewController.pool = self.pool
                
                ActivityManager.sharedInstance.resetActivity()
                
                self.presentViewController(poolDoneNavigationController, animated: true, completion: nil)
            }
        }
    }
}


// MARK: - SwitchDelegate

extension PoolViewController: SwitchDelegate {
    
    func showPoolSwitchAlert(text: String){
        let alertController = UIAlertController(title: "Paid to Go", message:
            text, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Walk/Run", style: UIAlertActionStyle.Default,handler: poolSwitchWalkRunSelected))
        alertController.addAction(UIAlertAction(title: "Bike", style: UIAlertActionStyle.Default,handler: poolSwitchBikeSelected))
        alertController.addAction(UIAlertAction(title: "Train/Bus", style: UIAlertActionStyle.Default,handler: poolSwitchTrainBusSelected))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel,handler: poolSwitchResume))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func poolSwitchWalkRunSelected(alert: UIAlertAction!) {
        print("Walk/Run")
        if type == PoolTypeEnum.Walk {
            return
        } else {
            type = PoolTypeEnum.Walk
            setPoolTitle(self.type!)
            self.backgroundImageView.image = UIImage(named: kWalkBackgroundImage)
            self.stepCountLabel.hidden = true
            
            UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                }, completion: { (result) in
                    self.pauseResumeTracking()
            })
        }
    }
    
    func poolSwitchBikeSelected(alert: UIAlertAction!) {
        print("Bike")
        if type == PoolTypeEnum.Bike {
            return
        } else {
            type = PoolTypeEnum.Bike
            setPoolTitle(self.type!)
            self.backgroundImageView.image = UIImage(named: kRunBackgroundImage)
            self.stepCountLabel.hidden = true
            
            UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                }, completion: { (result) in
                    self.pauseResumeTracking()
            })
        }
    }
    
    func poolSwitchTrainBusSelected(alert: UIAlertAction!) {
        print("Train/Bus")
        if type == PoolTypeEnum.Train {
            return
        } else {
            let vc = StoryboardRouter.homeStoryboard().instantiateViewControllerWithIdentifier("AnticheatViewController") as! AntiCheatViewController
            vc.pool = pool
            self.showViewController(vc, sender: nil)
        }
    }
    
    func poolSwitchResume(alert: UIAlertAction!) {
        self.pauseResumeTracking()
    }
}


// MARK: - PedometerDelegate

extension PoolViewController: PedometerDelegate {
    
    func beginPedometerUpdates() {
        
        if CMPedometer.isStepCountingAvailable() {
            // Pedometer available
            queryPedometerUpdates()
            
        } else {
            // Pedometer not available for device
            self.stepCountLabel.hidden = true
        }
    }
    
    func pausePedometerUpdates() {
        
        pedoMeter.stopPedometerUpdates()
        
        if self.type == .Walk {
            self.stepCountLabel.text = "Steps: \(self.stepCount)"
        }
    }
    
    func resumePedometerUpdates() {
        
        if CMPedometer.isStepCountingAvailable() {
            
            pedoMeter.startPedometerUpdatesFromDate(NSDate(), withHandler: { (data, error) in
                if let dataUpdated = data {
                    self.stepCount = dataUpdated.numberOfSteps.integerValue
                    if self.type == .Walk {
                        self.stepCountLabel.text = "Steps: \(self.stepCount)"
                    }
                }
            })
            
        } else {
            self.stepCountLabel.hidden = true
        }
        
    }
    
    func updatePedometer() {
        
        if !hasPausedAndResumedActivity {
            beginPedometerUpdates()
        } else {
            resumePedometerUpdates()
        }
    }
    
    @objc func queryPedometerUpdates() {
        
        guard let startDate = self.startDateToTrack else {
            return
        }
        self.pedoMeter.queryPedometerDataFromDate(startDate, toDate: NSDate()) { (data, error) in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                // Background
                if let dataUpdated = data {
                    self.stepCount = dataUpdated.numberOfSteps.integerValue
                }
                dispatch_async(dispatch_get_main_queue(), {
                    // Main
                    self.stepCountLabel.text = "Steps: \(self.stepCount)"
                })
            }
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension PoolViewController: ActivityLocationManagerDelegate {
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
    }
    
    func startLocationUpdates() {
        locationManager?.startUpdatingLocation()
    }
    
    func pauseLocationUpdates() {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
                
        if ActivityManager.sharedInstance.startLongitude == 0.0 {
            locationUpdatedFirstTime(locationObj)
        } else {
            locationUpdatedSuccessiveTimes(locationObj)
        }
    }
    
    private func locationUpdatedFirstTime(location:CLLocation) {
        ActivityManager.sharedInstance.startLatitude = location.coordinate.latitude
        ActivityManager.sharedInstance.startLongitude = location.coordinate.longitude
        
        ActivityManager.setLastLocation(location)
        ActivityManager.setLastSubrouteInitialLocation(location)
        
        self.mapButton.hidden = false
    }
    
    private func locationUpdatedSuccessiveTimes(location:CLLocation) {
        ActivityManager.updateMilesCounter(location)
        
        let angle = ActivityManager.getCircularProgressAngle()
        print("Angle - \(angle.description)")
        circularProgressView.angle = angle / circularProgressRoundOffset
        
        ActivityManager.setLastLocation(location)
        
        if let mapVC = mapViewController as MapViewController? {
            mapVC.addTravelSectionToMap(location)
        }
    }
}

// MARK: - TimerDelegate
/*
extension PoolViewController: TimerDelegate {
    
    func timerWillStart(timer : Timer) {
        print("timerWillStart")
        
    }
    
    func timerDidFire(timer : Timer) {
        print("timerDidFire")
        
        //        AudioServicesPlaySystemSound(1016)
        //        locationManager.startUpdatingHeading()
        //        testCircularProgress()
    }
    
    func timerDidPause(timer : Timer) {
        print("timerDidPause")
        
    }
    
    func timerWillResume(timer : Timer) {
        print("timerWillResume")
        
    }
    
    func timerDidStop(timer : Timer) {
        print("timerDidStop")
    }
}
*/