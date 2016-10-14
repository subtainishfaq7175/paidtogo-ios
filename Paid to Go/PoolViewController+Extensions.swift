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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        setBorderToView(bannerImageView, color: CustomColors.NavbarTintColor().CGColor)
        
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
        
        mapButton.hidden = true
    }
    
    // MARK: - Private Methods
    
    private func initLayout() {
        super.setNavigationBarVisible(true)
        super.clearNavigationBarcolor()
        
        setCustomNavigationBackButton()
        
//        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
//        setBorderToView(bannerImageView, color: CustomColors.NavbarTintColor().CGColor)
        bannerImageView.yy_setImageWithURL(NSURL(string: (pool?.banner)!), options: .ShowNetworkActivity)
        
        setPoolTitle(self.type!)
        setPoolBackgroundImage(self.type!)
        
        if type != PoolTypeEnum.Car {
            
            let switchImage = UIImage(named: "ic_pool_switch")
            let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: switchImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PoolViewController.switchButtonPressed))
            self.navigationItem.rightBarButtonItem = rightButtonItem
        }
        
        if hasPausedAndResumedActivity {
            pauseButton.hidden = false
        } else {
            pauseButton.hidden = true
        }
    }
    private func initViews() {
        actionButtonView.round()
        mapButton.round()
        pauseButton.round()
    }
    private func initButtons() {
        actionButton.addTarget(self, action: #selector(PoolViewController.actionButtonPressed), forControlEvents: .TouchUpInside)
        pauseButton.addTarget(self, action: #selector(PoolViewController.pauseResumeButtonPressed), forControlEvents: .TouchUpInside)
        mapButton.addTarget(self, action: #selector(PoolViewController.mapButtonPressed), forControlEvents: .TouchUpInside)
    }
    private func setCustomNavigationBackButton() {
        // Disable the swipe to make sure you get your chance to save
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        
        // Add an invisible bar button so that the back button is closer to the left border of the screen
        let negativeSeparator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSeparator.width = -20;
        
        // Replace the default back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_back35x35"), style: .Plain, target: self, action: #selector(PoolViewController.customBackViewController))
        
        let leftBarButtonItems = [
            negativeSeparator,
            backButton
        ]
        
        self.navigationItem.leftBarButtonItems = leftBarButtonItems
    }
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
            startTracking()
            
            hasPoolStarted = true
            
            actionButton.setTitle("action_finish".localize(), forState: UIControlState.Normal)
            setPoolColor(self.actionButtonView, type: self.type!)
            
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
        self.pauseResumeTracking()
        self.showPoolSwitchAlert("Switch Pool")
    }
    
    // MARK: - Navigation
    
    func customBackViewController() {
        if hasPoolStarted {
            
            let alertController = UIAlertController(title: "Paid to Go", message:
                "Wait!! If you leave now, all your progress will be lost. Are you sure that you want to leave?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: backViewController))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: poolSwitchResume))
            
            self.presentViewController(alertController, animated: true, completion: {
                self.pauseResumeTracking()
            })
            
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    func backViewController(alert: UIAlertAction!) {
        ActivityManager.sharedInstance.resetActivity()
        self.navigationController?.popViewControllerAnimated(true)
    }
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
//            mapViewController.locationCoordinate = self.locationManager.location?.coordinate
            ActivityManager.setMapIsMainScreen(true)
            self.mapViewController = mapViewController
            break
        }
    }
}

// MARK: - TrackDelegate

extension PoolViewController: TrackDelegate {
    
    func pauseResumeTracking() {
        // Paused
        if isTimerTracking {
            
            pausePedometerUpdates()
            pauseTracking()
            pauseLocationUpdates()
            
        // Resumed
        } else {
            
            hasPausedAndResumedActivity = true
            ActivityManager.setPausedAndResumedActivity()
            ActivityManager.setFirstSubrouteAfterPausingAndResumingActivity(true)
            
            resumePedometerUpdates()
            startTracking()
            startLocationUpdates()
        }
    }
    func startTracking() {
        
        pauseButton.setTitle("Pause", forState: UIControlState.Normal)
        isTimerTracking = true
        countingSteps = true
        
        if !hasPausedAndResumedActivity {
            print("Pool - Start date time -")
            ActivityManager.setStartDateTime()
        }
        
        updatePedometer()
    }
    func pauseTracking() {
        pauseButton.setTitle("Resume", forState: UIControlState.Normal)
        isTimerTracking = false
        countingSteps = false
    }
    func endTracking() {
        activity.startLatitude = ActivityManager.sharedInstance.startLatitude
        activity.startLongitude = ActivityManager.sharedInstance.startLongitude
        activity.endLatitude = ActivityManager.sharedInstance.endLatitude
        activity.endLongitude = ActivityManager.sharedInstance.endLongitude
        
        activity.milesTraveled = String(format: "%.2f", ActivityManager.getMilesCounter())
        activity.startDateTime = ActivityManager.getStartDateTime()
//        activity.poolId = ActivityManager.sharedInstance.poolId
        activity.poolId = self.pool?.internalIdentifier
        activity.accessToken = User.currentUser?.accessToken
        
        if let validationPhoto = validationPhoto {
            activity.photography = validationPhoto
        }
        
        print(activity.toString())
        
        pauseLocationUpdates()
        stopPedometer()
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.postRegisterActivity(self.activity) { (activityResponse, error) in
            
            self.dismissProgressHud()
            
            if let _ = error {
                self.showAlert("Unable to connect with the server. Please verify your internet connection and try again")
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
                
                if self.quickSwitchBetweenPools {
                    wellDoneViewController.switchPoolType = self.quickSwitchPoolType
                }
                
                ActivityManager.sharedInstance.resetActivity()
                
                self.presentViewController(poolDoneNavigationController, animated: true, completion: nil)
            }
        }
    }
}


// MARK: - SwitchDelegate

extension PoolViewController: SwitchDelegate {
    
    func showPoolSwitchAlert(text: String){
        
        if !hasPoolStarted {
            self.showAlert("The pool hasn't started, you can't switch to another pool!!")
            
            return
        }
        
        let alertController = UIAlertController(title: "Paid to Go", message:
            text, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Walk/Run", style: UIAlertActionStyle.Default,handler: poolSwitchWalkRunSelected))
        alertController.addAction(UIAlertAction(title: "Bike", style: UIAlertActionStyle.Default,handler: poolSwitchBikeSelected))
        alertController.addAction(UIAlertAction(title: "Train/Bus", style: UIAlertActionStyle.Default,handler: poolSwitchTrainBusSelected))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel,handler: poolSwitchResume))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func poolSwitchWalkRunSelected(alert: UIAlertAction!) {
        print("Switch - Walk/Run -")
        
        quickSwitchBetweenPools = true
        quickSwitchPoolType = PoolTypeEnum.Walk
        endTracking()
    }
    
    func poolSwitchBikeSelected(alert: UIAlertAction!) {
        print("Switch - Bike -")
        
        quickSwitchBetweenPools = true
        quickSwitchPoolType = PoolTypeEnum.Bike
        endTracking()
    }
    
    func poolSwitchTrainBusSelected(alert: UIAlertAction!) {
        print("Switch - Train/Bus -")
        
        quickSwitchBetweenPools = true
        quickSwitchPoolType = PoolTypeEnum.Train
        endTracking()
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
    func stopPedometer() {
        self.pedoMeter.stopPedometerUpdates()
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
        locationManager.activityType = .Fitness
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // Set Location Manager precision: http://stackoverflow.com/questions/9746675/cllocationmanager-responsiveness
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0;
        
        locationManager.requestAlwaysAuthorization()
    }
    func startLocationUpdates() {
        locationManager?.startUpdatingLocation()
    }
    func pauseLocationUpdates() {
        locationManager?.stopUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        mapButton.hidden = false
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        // Ignore updates with low precision: http://stackoverflow.com/questions/24867927/accuracy-of-core-location
        if locationObj.horizontalAccuracy > 70 {
            ActivityManager.setTestCounterRejected()
            return;
        }
        
        if ActivityManager.sharedInstance.startLongitude == 0.0 {
            
            // We ignore the first location update to allow the GPS to configure its accuracy
            if firstLocationUpdate {
                firstLocationUpdate = false
                mapButtonPressed()
            } else {
                locationUpdatedFirstTime(locationObj)
//                mapButtonPressed()
            }
            
        } else {
            locationUpdatedSuccessiveTimes(locationObj)
        }
    }
    private func locationUpdatedFirstTime(location:CLLocation) {
        
        ActivityManager.sharedInstance.startLatitude = location.coordinate.latitude
        ActivityManager.sharedInstance.startLongitude = location.coordinate.longitude
        ActivityManager.sharedInstance.endLatitude = location.coordinate.latitude
        ActivityManager.sharedInstance.endLongitude = location.coordinate.longitude
        
        ActivityManager.setLastLocation(location)
        ActivityManager.setLastSubrouteInitialLocation(location)
        
        self.mapButton.hidden = false
    }
    private func locationUpdatedSuccessiveTimes(location:CLLocation) {
        
        if isTimerTracking {
            
            ActivityManager.sharedInstance.endLatitude = location.coordinate.latitude
            ActivityManager.sharedInstance.endLongitude = location.coordinate.longitude
            
            if hasPausedAndResumedActivity {
                hasPausedAndResumedActivity = false
                
                ActivityManager.setLastSubrouteInitialLocation(location)
            }
            
            ActivityManager.setLastLocation(location)
            
            // If the map has allready been loaded at least once
            if let mapVC = mapViewController as MapViewController? {
                
                mapVC.addTravelSectionToMap(location)
                
                let milesTravelled = ActivityManager.getMilesCounter()
                self.progressLabel.text = String(format: "%.2f", milesTravelled)
                
                let angle = ActivityManager.getCircularProgressAngle()
                circularProgressView.angle = angle / circularProgressRoundOffset
            }

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
