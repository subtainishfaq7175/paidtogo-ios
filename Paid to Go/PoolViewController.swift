//
//  PoolViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 4/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import KDCircularProgress
import Foundation
import CoreLocation
import CoreMotion
import AVFoundation

class PoolViewController: ViewController {
    
    internal let kWalkBackgroundImage = "pool_background_walk"
    internal let kRunBackgroundImage = "pool_background_bike"
    internal let kTrainBackgroundImage = "pool_background_train"
    internal let kCarPoolBackgroundImage = "pool_background_carpool"
    
    // MARK: - Outlets
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    //@IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    // MARK: - Test Outlets
    
    @IBOutlet weak var D: UILabel!
    @IBOutlet weak var d1: UILabel!
    @IBOutlet weak var angle: UILabel!
    
    // MARK: - Variables and Constants
    
    let kBikeTimeUpdateSpeed = 2.0
    let kWalkTimeUpdateSpeed = 5.0
    
    var pool: Pool?
    var poolType: PoolType?
    var type: PoolTypeEnum?
    var hasPoolStarted = false
    var isTimerTracking: Bool = false
    var timer : NSTimer?
    
    var timerTest : Timer!
    
    var trackNumber = 0.0
    var locationManager: CLLocationManager!
    var activity: Activity!
    var stepCount = 0
    let pedoMeter = CMPedometer()
    var startDateToTrack: NSDate?
    var initialLocation: CLLocation?
    var finalLocation: CLLocation = CLLocation(latitude: ActivityManager.sharedInstance.endLatitude, longitude: ActivityManager.sharedInstance.endLongitude)
    var milesTraveled = "0.0"
    
    var screenshot : UIImage?
    
    var countingSteps : Bool?
    var hasPausedAndResumedActivity = false
    
    var metersFromLocation = 1600.0
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    var distanceToFinalDestination: Double = 0.0
    
    // MARK: -  Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initLayout()
        initLocationManager()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if(screenSize.height == 480.0) { //iPhone 4S
            self.circularProgressCenterYConstraint.constant = 0
        }
        
//        self.backgroundImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
        if type == .Walk && CMPedometer.isStepCountingAvailable() {
            self.stepCountLabel.hidden = false
        } else {
            self.stepCountLabel.hidden = true
        }
        
        var timerInterval = 0.0
        
        if self.type == PoolTypeEnum.Walk {
            print("TIMER INTERVAL -> 4 Secs")
            timerInterval = 4.0
        } else if self.type == PoolTypeEnum.Bike {
            print("TIMER INTERVAL -> 2 Secs")
            timerInterval = 2.0
        } else {
            print("TIMER INTERVAL -> 0.5 Secs")
            timerInterval = 0.5
        }
        
        timerTest = Timer(interval: timerInterval, delegate: self)
        
        // CONFIGURE VIEW WITH INITIAL ACTIVITY VALUES
        let trackNumber = ActivityManager.sharedInstance.getTrackNumber()
        
        let circularProgressAngle = trackNumber * 360
        print("CIRCULAR PROGRESS ANGLE: \(circularProgressAngle)")
        
        self.circularProgressView.angle = circularProgressAngle
        
        let milesCounter = ActivityManager.sharedInstance.getMilesCounter()
        self.progressLabel.text = String(format: "%.2f", milesCounter)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        case "wellDoneSegue":
            let wellDoneNavigationController = segue.destinationViewController as! UINavigationController
            let wellDoneViewController = wellDoneNavigationController.viewControllers.first as! WellDoneViewController
            
            wellDoneViewController.type = self.type
            break
        default:
            break
        }
    }
    
    // MARK: - Functions
    
    private func initLayout() {
        pauseButton.hidden = true
        
        setNavigationBarVisible(true)
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        clearNavigationBarcolor()
        setPoolTitle(self.type!)
        
        setPoolBackgroundImage(self.type!)
        
        if type != PoolTypeEnum.Car {
        
            let switchImage = UIImage(named: "ic_pool_switch")
            let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: switchImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PoolViewController.switchBetweenPools(_:)))
            self.navigationItem.rightBarButtonItem = rightButtonItem
        }
    }
    
    func btnBack(sender: AnyObject) {
        print("BACK")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initViews() {
        actionButtonView.round()
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
        case .Car:
            let titleImage = UIImage(named: kCarPoolBackgroundImage)
            self.backgroundImageView.image = titleImage
            break
        default:
            break
        }
    }
    
    func startTracking() {
        isTimerTracking = true
        countingSteps = true
        updatePedometer()
    }
    
    func pauseTracking() {
        if isTimerTracking {
            // PAUSE
            isTimerTracking = false
            pauseButton.setTitle("Resume", forState: UIControlState.Normal)
            countingSteps = false
        } else {
            // RESUME
            resumePedometerUpdates()
            hasPausedAndResumedActivity = true
            startTracking()
            isTimerTracking = true
            pauseButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
    
    private func endTracking() {
        
        print(activity.startLatitude)
        print(activity.startLongitude)
        print(activity.endLatitude)
        print(activity.endLongitude)
        
        activity.startLatitude = ActivityManager.sharedInstance.startLatitude
        activity.startLongitude = ActivityManager.sharedInstance.startLongitude
        activity.endLatitude = ActivityManager.sharedInstance.endLatitude
        activity.endLongitude = ActivityManager.sharedInstance.endLongitude
        
        activity.milesTraveled = String(format: "%.2f", ActivityManager.sharedInstance.metersFromStartLocation * 0.000621371) //self.milesTraveled
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
    
    @objc func testCircularProgress() {
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //Do background work
            print("BACKGROUND")
            //self.trackNumber += 0.1
            
            dispatch_async(dispatch_get_main_queue(), {
                //Update
                print("MAIN")
                self.trackNumber = self.trackNumber + 0.1
                
                print("TRACK NUMBER: \(self.trackNumber)")
                self.circularProgressView.angle = self.trackNumber * 360
                
                if self.trackNumber > 1 {
                    print("INVALIDATE TIMER")
                    self.timer.invalidate()
                }
            })
        }
        */
    }
    
    private func updatePedometer() {
        
        if !hasPausedAndResumedActivity {
            beginPedometerUpdates()
        } else {
            resumePedometerUpdates()
        }
    }
    
    /**
     *  Called the first time, when the user begins the activity
     */
    private func beginPedometerUpdates() {

        if CMPedometer.isStepCountingAvailable() {
            // PEDOMETER AVALIABLE
            queryPedometerUpdates()
            
        } else {
            // PEDOMETER NOT AVALIABLE FOR DEVICE
            self.stepCountLabel.hidden = true
        }
    }
    
    /**
     *  Called when the user pauses the activity
     */
    private func pausePedometerUpdates() {

        pedoMeter.stopPedometerUpdates()
        
        if self.type == .Walk {
            self.stepCountLabel.text = "Steps: \(self.stepCount)"
        }
    }
    
    /**
     *  Called after the user pauses the activity and resumes it
     */
    private func resumePedometerUpdates() {
        
        if CMPedometer.isStepCountingAvailable() {
            print("RESUME PEDOMETER")
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
    
    func startQueriedPedometerUpdates() {
        timerTest.start(timerTest.timer)
    }
    
    /**
     *  Called after constants periods of time to check for pedometer updates
     */
    @objc private func queryPedometerUpdates() {
        print("QUERY PEDOMETER")
        
        guard let startDate = self.startDateToTrack else {
            return
        }
        self.pedoMeter.queryPedometerDataFromDate(startDate, toDate: NSDate()) { (data, error) in
            print("QUERY PEDOMETER FOR UPDATE DATA")

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                //Do background work
                print("BACKGROUND")
                if let dataUpdated = data {
                    self.stepCount = dataUpdated.numberOfSteps.integerValue
                }
                dispatch_async(dispatch_get_main_queue(), {
                    //Update
                    print("MAIN")
                    self.stepCountLabel.text = "Steps: \(self.stepCount)"
                })
            }
        }
    }
    
    private func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Actions
    
    @IBAction func pause(sender: AnyObject) {
        pauseTracking()
        pausePedometerUpdates()
    }
    
    @IBAction func switchBetweenPools(sender: AnyObject) {
        
        self.timerTest.pause()
        self.pauseTracking()
        self.showPoolSwitchAlert("Switch Pool")
    }
    
    @IBAction func track(sender: AnyObject) {
        
        if !hasPoolStarted {
            
            activity = Activity()
            
            self.startDateToTrack = NSDate()
            
            hasPoolStarted = true
            actionButton.setTitle("action_finish".localize(), forState: UIControlState.Normal)
            setPoolColor(self.actionButtonView, type: self.type!)
            
            startTracking()
            pauseButton.hidden = false
            
            locationManager?.startUpdatingLocation()
            
//            startQueriedPedometerUpdates()
        } else {
            
            countingSteps = false
            endTracking()

        }
    }
    
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
            setPoolBackgroundImage(self.type!)
            self.backgroundImageView.image = UIImage(named: kWalkBackgroundImage)
            self.stepCountLabel.hidden = false
            
            UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                }, completion: { (result) in
                    self.pauseTracking()
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
            setPoolBackgroundImage(self.type!)
            self.backgroundImageView.image = UIImage(named: kRunBackgroundImage)
            self.stepCountLabel.hidden = true
            
            UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                }, completion: { (result) in
                    self.pauseTracking()
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
        self.timerTest.pause()
        self.pauseTracking()
    }
}

extension PoolViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        AudioServicesPlaySystemSound(1016)
        
        if ActivityManager.sharedInstance.startLongitude == 0.0 {
            
            ActivityManager.sharedInstance.startLatitude = coord.latitude
            ActivityManager.sharedInstance.startLongitude = coord.longitude
            
            // INITIAL LOCATION
            ActivityManager.sharedInstance.initialLocation = locationObj
            
            // FINAL LOCATION
            ActivityManager.sharedInstance.endLocation = CLLocation(latitude: ActivityManager.sharedInstance.endLatitude, longitude: ActivityManager.sharedInstance.endLongitude)
            
            ActivityManager.sharedInstance.distanceToFinalDestination = (ActivityManager.sharedInstance.initialLocation.distanceFromLocation(ActivityManager.sharedInstance.endLocation))
            
        } else {
            
            ActivityManager.sharedInstance.metersFromStartLocation = locationObj.distanceFromLocation(ActivityManager.sharedInstance.initialLocation) // d1
            
            self.milesTraveled = String(format: "%.2f", ActivityManager.sharedInstance.metersFromStartLocation * 0.000621371)
            self.progressLabel.text = milesTraveled
            
            ActivityManager.sharedInstance.milesCounter += (ActivityManager.sharedInstance.metersFromStartLocation * 0.000621371)
            ActivityManager.sharedInstance.trackNumber = ActivityManager.sharedInstance.metersFromStartLocation / distanceToFinalDestination
            
            let angle = ActivityManager.sharedInstance.trackNumber * 360
            circularProgressView.angle = angle
            
            ActivityManager.sharedInstance.endLatitude = coord.latitude
            ActivityManager.sharedInstance.endLongitude = coord.longitude
            
            self.D.text = "D - DESTINO FINAL: \(distanceToFinalDestination)"
            self.d1.text = "d1 - DIST AL ORIGEN: \(ActivityManager.sharedInstance.metersFromStartLocation)"
            self.angle.text = "angle - ANGULO: \(angle)"
        }
    }
}

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
