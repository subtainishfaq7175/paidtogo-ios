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
    
    // MARK: - Outlets
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
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
        
        if type == .Walk {
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
        
        let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: switchImage, style: UIBarButtonItemStyle.Plain, target: self, action: "switchBetweenPools:")
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    private func initViews() {
        actionButtonView.round()
    }
    
    
    func startTracking() {
        isTimerTracking = true
        updatePedometer()
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
    
    private func updatePedometer() {
        if CMPedometer.isStepCountingAvailable() {
            pedoMeter.queryPedometerDataFromDate(self.startDateToTrack!, toDate: NSDate()) { (data, error) in
                if let data = data{
                    self.stepCount = data.numberOfSteps.integerValue
                    
                    if self.type == .Walk {
                        self.stepCountLabel.text = "Steps: \(self.stepCount)"
                    }
                    
                }
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
    
  
    
    @IBAction func toggle(sender: AnyObject) {
        if isTimerTracking {
            isTimerTracking = false
            pauseButton.setTitle("Resume", forState: UIControlState.Normal)
        } else {
            startTracking()
            isTimerTracking = true
            pauseButton.setTitle("Pause", forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func switchBetweenPools(sender: AnyObject) {
        
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

        } else {
            
            endTracking()

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
            
            let metersFromLocation = locationObj.distanceFromLocation(self.initialLocation!)
            
            self.milesTraveled = String(format: "%.2f", metersFromLocation * 0.000621371)
            
            self.progressLabel.text = milesTraveled
            
            trackNumber = metersFromLocation / 1600
            circularProgressView.angle = trackNumber * 360
            
            activity.endLatitude = coord.latitude
            activity.endLongitude = coord.longitude
                
        }
    }
    
}
