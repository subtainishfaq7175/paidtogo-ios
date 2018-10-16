//
//  ActivityMoniteringViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 6/28/18.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import KDCircularProgress
import ObjectMapper
import CoreLocation
import CoreMotion

enum ActivityState : Int {
    case stop = 0
    case start = 1
    case pause = 2
}

class ActivityMoniteringViewController: MenuContentViewController, ActivityMoniteringManagerDelegate {

    // MARK: - IBOutlets -
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
//    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
//    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet var speedView: SpeedView!
    @IBOutlet var avgSpeedView: SpeedView!
    
    @IBOutlet weak var elaspedTimeView: UIView!
    @IBOutlet weak var elaspedTimeLabel: UILabel!
    
    var totalAverageSpeedMutiple = 0.0
    var totalSpeedupdtes = 0
    
    var isCycling: Bool = false
    var showBackButton: Bool = false
    
    var totalStepsUptillNow = 0
    var totalMilesUptillNow = 0.0
    
    var activityState = ActivityState.stop
    
    var currentActivity = ManualActivity()
    
    var mapViewController : ActivityMapViewController?
    
    // In case of pause we will add the array to make one
    var activities : [ManualActivity] = []
    
    var coordinates : [[CLLocation]] = []
    var currentCoordinates : [CLLocation] = []
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    
    var startDate: Date!
    var traveledDistance: Double = 0
    
    var cyclingTimer: Timer = Timer()
    
    // To 
    var nonCyclingActivitesCount = 0
    var cyclingFixedTimePassed = false
    
    var activityTimer: Timer = Timer()
    var totalTimeForActivity: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNavigationBarVisible(visible: true)
        if showBackButton {
            customizeNavigationBarWithBack()
        } else {
            customizeNavigationBarWithMenu()
        }

        ActivityMoniteringManager.sharedManager.delegate = self
        actionButtonView.layer.cornerRadius = (actionButtonView.bounds.height / 2) - 2
        
        bannerView.layer.cornerRadius = (bannerView.bounds.height / 2)
        bannerView.layer.borderWidth = 2.0
        bannerView.layer.borderColor = UIColor.black.cgColor
        
        pauseButton.round()
        mapButton.round()
        
        elaspedTimeView.round()
        elaspedTimeView.addBorders()
        
        getSponsors()
        
        showInitailPopUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityMoniteringViewController.locationUpdated(notification:)), name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_LOCATION_UPDATED), object: nil)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(openMapViewController))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(openMapViewController))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
      
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapViewController = nil
        
        if Settings.shared.isAutoTrackingOn {
//            actionButton.isHidden = true
//            actionButtonView.isHidden = true
            
//            let startOftheDay = Calendar.current.startOfDay(for: Date())
//            ActivityMoniteringManager.sharedManager.trackRunning(from: startOftheDay)
        } else {
//            actionButton.isHidden = false
//            actionButtonView.isHidden = false
//            ActivityMoniteringManager.sharedManager.stopTracking()
          // stop updates
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action Methods
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        if activityState != .start {
            startAction()
        } else if activityState == .start {
            pauseAction()
        }
    }
    
    // this is the stop button
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
      
        if activityState != .stop {
            stopAction()
        }
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        openMapViewController()
    }
    
    @objc func openMapViewController() {
        mapViewController = StoryboardRouter.initialMapViewController()
        
        // Send Miles to map through activity
        let activity = ManualActivity()
        
        if currentActivity.type == .walkingRunning {
            activity.steps = totalStepsUptillNow + ((activityState == .start) ? self.currentActivity.steps : 0)
            activity.milesTraveled = totalMilesUptillNow + ((activityState == .start) ? self.currentActivity.milesTraveled : 0.0)
        } else if currentActivity.type == .cycling {
            activity.milesTraveled = traveledDistance * 0.000621371
        }
        
        mapViewController!.activity = activity
        
        coordinates.append(currentCoordinates)
        currentCoordinates = []
        
        mapViewController!.coordinates = coordinates
        
        self.present(mapViewController!, animated: true, completion: nil)
    }
    
    
    // MARK: - Private Methods
    
    func showInitailPopUp() {
        
        if Settings.shared.isAutoTrackingOn, !Settings.shared.trackingNotRequiredPopUpAlreadyShown {
            Settings.shared.trackingNotRequiredPopUpAlreadyShown = true
            showAlert(text: "autoTrackingStartActivityNotRequired".localize())
        }
    }
    
    private func startAction() {
        
        if activityState == .stop {
            currentActivity = ManualActivity()
            showActivitySelectionSheet()
            
            lastLocation = nil
            traveledDistance = 0
            
        } else if activityState == .pause {
            let type = currentActivity.type
            
            currentActivity = ManualActivity()
            currentActivity.type = type
            
            startActivity()
        }
    }
    
    private func startActivity() {
        currentActivity.startDate = Date()
        currentActivity.startLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
        currentActivity.startLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
        
        activityState = .start
        
        // Adjust UI For state Start
        setupUI(forState: activityState)
        
        if currentActivity.type == .walkingRunning {
            ActivityMoniteringManager.sharedManager.trackRunning()
        } else if currentActivity.type == .cycling {
//            ActivityMoniteringManager.sharedManager.trackCycling()
            GeolocationManager.sharedInstance.startLocationUpdates()
            cyclingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    private func pauseAction() {
        // Setup activities for pause state
        ActivityMoniteringManager.sharedManager.stopTracking()
        currentActivity.endDate = Date()
        currentActivity.endLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
        currentActivity.endLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
        
        totalMilesUptillNow = totalMilesUptillNow + currentActivity.milesTraveled
        totalStepsUptillNow = totalStepsUptillNow + currentActivity.steps
        
        activities.append(currentActivity)
        
        coordinates.append(currentCoordinates)
        currentCoordinates = []
        lastLocation = nil
        
        activityState = .pause
        
        cyclingTimer.invalidate()
        
        // Adjust UI For state Start
        setupUI(forState: activityState)
    }
    
    private func stopAction() {
        
        if activityState != .pause  {
            // Add last activity.
            // This might be the only activity
            
            currentActivity.endDate = Date()
            currentActivity.endLat = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude
            currentActivity.endLong = GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude
            
            totalMilesUptillNow = totalMilesUptillNow + currentActivity.milesTraveled
            totalStepsUptillNow = totalStepsUptillNow + currentActivity.steps
            
            activities.append(currentActivity)
            
            coordinates.append(currentCoordinates)
            currentCoordinates = []
        }
        
        ActivityMoniteringManager.sharedManager.stopTracking()
        
        addAllActivities()
        
        activities = []
    
        activityState = .stop
        
        // Adjust UI For state Start
        setupUI(forState: activityState)
    }
    
    private func addAllActivities() {
        // add all activities to make one
        currentActivity = ManualActivity()
        
        let lastActivity = activities.last
        let firstActivity = activities.first
        
        currentActivity.type = (firstActivity?.type)!
        currentActivity.startLat = firstActivity?.startLat
        currentActivity.startLong = firstActivity?.startLong
        
        currentActivity.endLat = lastActivity?.endLat
        currentActivity.endLong = lastActivity?.endLong
        
        for activityItem in activities {
            currentActivity.milesTraveled = currentActivity.milesTraveled + activityItem.milesTraveled
            currentActivity.steps = currentActivity.steps + activityItem.steps
        }
        
        if currentActivity.type == .cycling {
            currentActivity.milesTraveled = traveledDistance * 0.000621371
            currentActivity.steps = 0
        }
        
        self.totalStepsUptillNow = currentActivity.steps
        self.totalMilesUptillNow = currentActivity.milesTraveled 
        
        if Settings.shared.isAutoTrackingOn {
            
//           showAlert(text: "autoTrackingStartActivityNotRequired".localize())
            
            let viewControler = StoryboardRouter.wellDoneViewController()
            let activity = ManualActivity()
            activity.steps = self.totalStepsUptillNow
            activity.milesTraveled = self.totalMilesUptillNow
            viewControler.activityType = self.currentActivity.type
            viewControler.activity = activity

            self.navigationController?.pushViewController(viewControler, animated: true)
            
            resetVariables()
            
            // in case of auto tracking post the data if the user has done some activity so it is updated in real time
            ActivityMoniteringManager.sharedManager.postDataAutomatically()
        } else {
            // send that activity to server
            showProgressHud()
            DataProvider.sharedInstance.registerActivites(ActivityMoniteringManager.sharedManager.getJSONArray(fromActivities: [currentActivity]) as [AnyObject]) { (response, error) in
                
                self.dismissProgressHud()
                
                if error == nil {
                    if let activityData :ActivityNotification = Mapper<ActivityNotification>().map(JSON:response as! [String : Any]) {
                        let viewControler = StoryboardRouter.wellDoneViewController()
                        activityData.totalSteps = self.totalStepsUptillNow
                        viewControler.activityResponse = activityData
                        viewControler.activityType = self.currentActivity.type
                        
                        self.navigationController?.pushViewController(viewControler, animated: true)
                        
                        
                    }
                } else {
                    ActivityMoniteringManager.sharedManager.save(activity: self.currentActivity)
                    
                    // Show Activity data even if not synced
                    let viewControler = StoryboardRouter.wellDoneViewController()
                    viewControler.activity = self.currentActivity
                    
                    self.navigationController?.pushViewController(viewControler, animated: true)
                }
                
                self.resetVariables()
            }
            
        }
    }
    
    private func setupUI(forState state: ActivityState) {
        switch state {
            
        case .stop:
            stepCountLabel.text = "Steps: 0"
            progressLabel.text = "0.0"
            circularProgressView.angle = 0
            actionButton.setTitle("Start", for: .normal)
            pauseButton.isHidden = true
            elaspedTimeView.isHidden = true
            
            totalStepsUptillNow = 0
            totalMilesUptillNow = 0.0
            speedView.setCurrentSpeed(speed: 0)
            avgSpeedView.setCurrentSpeed(speed: 0)
            
            
            stopActivityTimer()
            break
        case .start:
            pauseButton.isHidden = false
             elaspedTimeView.isHidden = false
            
            actionButton.setTitle("Pause", for: .normal)
           
            startActivityTimer()
            break
        case .pause:
            pauseButton.isHidden = false
            elaspedTimeView.isHidden = false
            actionButton.setTitle("Resume", for: .normal)
            speedView.setCurrentSpeed(speed: 0)
            
            pauseActivityTimer()
            break
        }
    }
    
    private func showActivitySelectionSheet() {
        let alertController = UIAlertController(title: "Activities", message: "Select an Activity to start.", preferredStyle: .actionSheet)
        
        let walkingAction = UIAlertAction(title: "Walk/Run", style: .default) { walkingAction in
            self.stepCountLabel.isHidden = false
            self.startActivity()
            ActivityMoniteringManager.sharedManager.trackWalking()
            self.currentActivity.type = .walkingRunning
        }
//        let runningAction = UIAlertAction(title: "Running", style: .default) { runningAction in
//            self.stepCountLabel.isHidden = false
//            self.clearUI()
//            ActivityMoniteringManager.sharedManager.trackRunning()
//            self.activity.type = .walkingRunning
//        }
        let cyclingAction = UIAlertAction(title: "Bike", style: .default) { cyclingAction in
            self.stepCountLabel.isHidden = true
            self.currentActivity.type = .cycling
            self.startActivity()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(walkingAction)
//        alertController.addAction(runningAction)
        alertController.addAction(cyclingAction)
//        alertController.addAction(gymCheckInAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateWalkingAndRunning(distance: Double, steps: NSNumber) {
        if activityState == .start {
            DispatchQueue.main.async {
                let totalDistance = self.totalMilesUptillNow + distance
                let totalSteps = self.totalStepsUptillNow + steps.intValue
                
                
                self.stepCountLabel.text = "Steps: \(totalSteps)"
                self.updateDistanceLabel(withTotalDistance: totalDistance)
                
                if let mapView = self.mapViewController {
                    // Send Miles to map through activity
                    let activity = ManualActivity()
                    activity.steps = totalSteps
                    activity.milesTraveled = totalDistance
                    mapView.activity = activity
                }
                
                
            }
            
            currentActivity.steps = steps.intValue
            currentActivity.milesTraveled = distance
        }
    }
    
    private func updateDistanceLabel(withTotalDistance distance: Double) {
    
        self.progressLabel.text = String(format: "%.2f", distance)
        
        // Update Angle
        var totalDistanceToNearestOrAwayFromZero = distance
        totalDistanceToNearestOrAwayFromZero.round(.toNearestOrAwayFromZero)
        totalDistanceToNearestOrAwayFromZero =  distance - totalDistanceToNearestOrAwayFromZero
        let angle = totalDistanceToNearestOrAwayFromZero * 360
        
        self.circularProgressView.angle = angle
    }
    
    private func resetVariables() {
        totalStepsUptillNow = 0
        totalMilesUptillNow = 0.0
        
        activityState = ActivityState.stop
        
        currentActivity = ManualActivity()
        
        mapViewController = nil
        
        activities = []
        
        coordinates = []
        currentCoordinates = []
    }
    
    //MARK: - Activity Timers
    
    private func startActivityTimer() {
        if let startDate = currentActivity.startDate {
            totalTimeForActivity = totalTimeForActivity + Date().timeIntervalSince(startDate)
        }
        
        activityTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateActivtyTimer)), userInfo: nil, repeats: true)
    }
    
    private func stopActivityTimer() {
        activityTimer.invalidate()
        totalTimeForActivity = 0
        
        if let startDate = currentActivity.startDate {
            totalTimeForActivity = totalTimeForActivity + Date().timeIntervalSince(startDate)
        }
        
         elaspedTimeLabel.text = stringFromTimeInterval(interval: 0)
    }
    
    private func pauseActivityTimer() {
        activityTimer.invalidate()
        
        if let startDate = currentActivity.startDate {
            totalTimeForActivity = totalTimeForActivity + Date().timeIntervalSince(startDate)
        }
        
        elaspedTimeLabel.text = stringFromTimeInterval(interval: totalTimeForActivity)
    }
    
    @objc private func updateActivtyTimer() {
        // update labels
        if let startDate = currentActivity.startDate {
            let totalTime = totalTimeForActivity + Date().timeIntervalSince(startDate)
            elaspedTimeLabel.text = stringFromTimeInterval(interval: totalTime)
        }
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    //MARK: - Location Updated
    
    @objc private func locationUpdated(notification: NSNotification) {
        let currentLocation = GeolocationManager.sharedInstance.getCurrentLocation()
        
        if activityState == .start {
            currentCoordinates.append(currentLocation)
            
            // add to current activity
            // If map is shown
            // Send to map as well, in this case the user will not be able to pause/ un pause the activity so will send the data only if the activity is in start state.
            if let mapViewController = mapViewController {
                mapViewController.addTravelSectionToMap(currentLocation: currentLocation)
            }
            
            let speed = currentLocation.speed * 3.6
            
            totalAverageSpeedMutiple = totalAverageSpeedMutiple + speed
            totalSpeedupdtes += 1
            
            let averageSpeed = totalAverageSpeedMutiple / Double(totalSpeedupdtes)
            
            avgSpeedView.setCurrentSpeed(speed: averageSpeed)
            speedView.setCurrentSpeed(speed: speed)
            
        if self.currentActivity.type == .cycling {
            if startDate == nil {
                startDate = Date()
            } else {
                print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
            }
            if lastLocation != nil {
                let location = currentLocation
                traveledDistance += lastLocation.distance(from: location)
                print("Traveled Distance:",  traveledDistance)
            }
            lastLocation = currentLocation
            
            if let mapView = mapViewController {
                let activity = ManualActivity()
                activity.currrentSpeed =  (currentLocation.speed * 2.23694)
                activity.currrentSpeed.roundToTwoDecinalPlace()
                activity.milesTraveled = traveledDistance * 0.000621371
                
                mapView.activity = activity
                
            }
            
            if (currentLocation.speed * 2.23694) > Double(5 + (MasterData.sharedData?.speedOnBike)!) {
                 pauseAction()
                showAlert(text: "We have detected that you have crossed the maximum speed allowed for biking i.e \(MasterData.sharedData?.speedOnBike ?? 0) mph")
                
                if let mapView = mapViewController {
                    mapView.showOverSpeedingAlert()
                }
            }
            
             updateDistanceLabel(withTotalDistance: traveledDistance * 0.000621371)
            }
        }
    }
    
    @objc private func updateTimer() {
        cyclingFixedTimePassed = true
    }
    
    //MARK: - ActivityMoniteringManagerDelegate Methods
    
    func didWalk(Steps steps: NSNumber, Distance distance:Double) {
        updateWalkingAndRunning(distance: distance, steps: steps)
    }
    
    func didRun(Steps steps: NSNumber, Distance distance:Double) {
        updateWalkingAndRunning(distance: distance, steps: steps)
    }
    
    func didCycling(activity: ManualActivity) {
        self.currentActivity = activity
        updateWalkingAndRunning(distance: activity.milesTraveled, steps: 0)
    }
    
    func didCycle(Speed speed: Double) {
        
    }
    
    func didCycle(Distance distance: Double) {
        
    }
    
    func didDetectActivity(Activity activity: CMMotionActivity) {
        if activity.confidence != .low {
            if activity.cycling, activity.stationary {
                nonCyclingActivitesCount = 0
            } else if !activity.unknown {
                if cyclingFixedTimePassed {
                    cyclingFixedTimePassed = false
                    
                    nonCyclingActivitesCount = nonCyclingActivitesCount + 1
                    
                    if nonCyclingActivitesCount > 4 {
                        pauseAction()
                        showAlert(text: "We have detected that you are not riding a bike!")
                        
                        if let mapView = mapViewController {
                            mapView.showNotRidingBikeAlert()
                        }
                    }
                }
            }
        }
    }
    
    func getSponsors()  {
        guard let userID = User.currentUser?.userId else {
            return
        }
//        self.showProgressHud()
        
        DataProvider.sharedInstance.getSponsors(userID, completion: { (data, error) in
//            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                
                return
            }
            
            var sponsors = [Sponsor]()
            
            if let data = data {
               
                for sponsor in data {
                    sponsors.append(sponsor)
                }
            }
            
            if sponsors.count > 0 {
                let viewController = StoryboardRouter.activitySponserViewController()
                viewController.sponsors = sponsors
                
                self.present(viewController, animated: true, completion: nil)
            }
            
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
