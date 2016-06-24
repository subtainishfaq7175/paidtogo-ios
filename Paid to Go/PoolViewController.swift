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

class PoolViewController: ViewController {
    
    internal let kWalkBackgroundImage = "pool_background_walk"
    internal let kRunBackgroundImage = "pool_background_bike"
    
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
    
    // MARK: - Variables and Constants
    
    var pool: Pool?
    var poolType: PoolType?
    var type: PoolTypeEnum?
    var hasPoolStarted = false
    var isTimerTracking: Bool = false
    var timer = NSTimer()
    var trackNumber = 0.0
    var locationManager: CLLocationManager!
    var activity: Activity!
    var stepCount = 0
    let pedoMeter = CMPedometer()
    var startDateToTrack: NSDate?
    var initialLocation: CLLocation?
    var milesTraveled = "0.0"
    
    var screenshot : UIImage?
    
    var countingSteps : Bool?
    var hasPausedAndResumedActivity = false
    
    var metersFromLocation = 1600.0
    
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
        
        self.backgroundImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
        if type == .Walk && CMPedometer.isStepCountingAvailable() {
                self.stepCountLabel.hidden = false
        }
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
        
        let switchImage = UIImage(named: "ic_pool_switch")
        
        let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: switchImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PoolViewController.switchBetweenPools(_:)))
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        /*
        let backImage = UIImage(named: "ic_back35x35")
        
        let leftButtonItem: UIBarButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PoolViewController.btnBack(_:)))
        
         self.negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
         self.negativeSeparator.width = -10;
 
        self.navigationItem.leftBarButtonItem = leftButtonItem
        */
    }
    
    func btnBack(sender: AnyObject) {
        print("BACK")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initViews() {
        actionButtonView.round()
    }
    
    
    func startTracking() {
        isTimerTracking = true
        countingSteps = true
        updatePedometer()
    }
    
    func pauseTracking() {
        if isTimerTracking {
            print("PAUSE")
            timer.invalidate()
            isTimerTracking = false
            pauseButton.setTitle("Resume", forState: UIControlState.Normal)
            countingSteps = false
        } else {
            print("RESUME")
            startQueriedPedometerUpdates()
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
        
        activity.milesTraveled = self.milesTraveled
        activity.startDateTime = String(self.startDateToTrack)
        activity.poolId = pool?.internalIdentifier
        activity.accessToken = User.currentUser?.accessToken
        
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
                
                self.presentViewController(poolDoneNavigationController, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc private func testCircularProgress() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //Do background work
            print("BACKGROUND")
            
            dispatch_async(dispatch_get_main_queue(), {
                //Update
                print("MAIN")
                self.trackNumber += 0.05
                print("TRACK NUMBER: \(self.trackNumber)")
                self.circularProgressView.angle = 359//self.trackNumber * 360
                
                if self.trackNumber > 1 {
                    print("INVALIDATE TIMER")
                    self.timer.invalidate()
                }
            })
        }
    }
    
    private func updatePedometer() {
        
        if !hasPausedAndResumedActivity {
            beginPedometerUpdates()
        } else {
            resumePedometerUpdates()
        }
        
        /*
        if CMPedometer.isStepCountingAvailable() {

            pedoMeter.startPedometerUpdatesFromDate(NSDate(), withHandler: { (data, error) in
                if let dataUpdated = data {
                    self.stepCount = dataUpdated.numberOfSteps.integerValue
                }
                
                if self.type == .Walk {
                    self.stepCountLabel.text = "Steps: \(self.stepCount)"
                }
            })
            
        } else {
            showAlert("Su dispositivo no cuenta con el hardware adecuado para contar los pasos")
            self.stepCountLabel.hidden = true
        }
        */
        
        /*
        self.stepCountLabel.hidden = false

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        countingSteps = true
            print("EMPIEZO CONTEO DE PASOS")
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                while self.countingSteps == true {
                    self.stepCount = self.stepCount + 1
                    
                    self.milesTraveled = String(format: "%.2f", Double(self.stepCount) * 0.06)
                    self.trackNumber = Double(self.stepCount) / 160
                    self.circularProgressView.angle = self.trackNumber * 36
                    
                    print("\(self.stepCount) PASOS")
                    print("ESPERO 1 SEGUNDO")
                    sleep(1)
                    
                    print("ACTUALIZO UI")
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        // update some UI
                        self.stepCountLabel.text = "Steps: \(self.stepCount)"
                        self.progressLabel.text = self.milesTraveled
                    }
                }
            }
        */
    }
    
    /**
     *  Called the first time, when the user begins the activity
     */
    private func beginPedometerUpdates() {
        
        if CMPedometer.isStepCountingAvailable() {
            print("BEGIN PEDOMETER")

            startQueriedPedometerUpdates()
            
        } else {
            showAlert("Su dispositivo no cuenta con el hardware adecuado para contar los pasos")
            self.stepCountLabel.hidden = true
        }
    }
    
    /**
     *  Called when the user pauses the activity
     */
    private func pausePedometerUpdates() {
        print("PAUSE PEDOMETER")
        /*
        pedoMeter.stopPedometerUpdates()
        
        if self.type == .Walk {
            self.stepCountLabel.text = "Steps: \(self.stepCount)"
        }
        */
        
        /*test*/timer.invalidate()
    }
    
    /**
     *  Called after the user pauses the activity and resumes it
     */
    private func resumePedometerUpdates() {
        /*
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
            showAlert("Su dispositivo no cuenta con el hardware adecuado para contar los pasos")
            self.stepCountLabel.hidden = true
        }
        */
        
        /*test*/startQueriedPedometerUpdates()
    }
    
    private func startQueriedPedometerUpdates() {
        print("startQueriedPedometerUpdates")
        timer.invalidate() // just in case this button is tapped multiple times
        
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(queryPedometerUpdates), userInfo: nil, repeats: true)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(testCircularProgress), userInfo: nil, repeats: true)
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
            
            /*test*/startQueriedPedometerUpdates()/*test*/

        } else {
            
            countingSteps = false
            endTracking()

        }
    }
    
    // MARK:- Helper methods
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
    func showPoolSwitchAlert(text: String){
        let alertController = UIAlertController(title: "Paid to Go", message:
            text, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Walk/Run", style: UIAlertActionStyle.Default,handler: poolSwitchWalkRunSelected))
        alertController.addAction(UIAlertAction(title: "Bike", style: UIAlertActionStyle.Default,handler: poolSwitchBikeSelected))
        alertController.addAction(UIAlertAction(title: "Train/Bus", style: UIAlertActionStyle.Default,handler: poolSwitchTrainBusSelected))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel,handler: nil))
        
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
            
            UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                }, completion: { (result) in
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
            
            UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                }, completion: { (result) in
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
}

extension PoolViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        if activity.startLongitude == nil {
            
            activity.startLatitude = coord.latitude
            activity.startLongitude = coord.longitude
            
            self.initialLocation = locationObj
            
        } else {
            
            let metersFromStartLocation = locationObj.distanceFromLocation(self.initialLocation!)
            
            self.milesTraveled = String(format: "%.2f", metersFromStartLocation * 0.000621371)
            
            self.progressLabel.text = milesTraveled
            
            trackNumber = metersFromStartLocation / 1600
            circularProgressView.angle = trackNumber * 360
            
            activity.endLatitude = coord.latitude
            activity.endLongitude = coord.longitude
        }
    }
}
