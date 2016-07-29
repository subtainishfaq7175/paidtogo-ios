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

// MARK: - Protocols

/**
 *  Handles the whole activity tracking process
 */
protocol TrackDelegate {
    
    /**
     *  Determines if the activity should be paused or resumed
     */
    func pauseResumeTracking()
    
    /**
     *  Begins tracking the activity:
     *
     *  -   Starts Pedometer (Walk/Run)
     *  -   Starts Geolocation updates
     */
    func startTracking()
    
    /**
     *  Pauses the tracking of the activity.
     */
    func pauseTracking()
    
    /**
     *  Finishes the activity tracking
     *  Prepares the activity info to be sent to the API
     */
    func endTracking()
}

/**
 *  Handles the step counting process
 */
protocol PedometerDelegate {
    
    /**
     *  Called the first time, when the user begins the activity
     */
    func beginPedometerUpdates()
    
    /**
     *  Called every time the user pauses the activity
     */
    func pausePedometerUpdates()
    
    /**
     *  Called every time the user resumes the activity
     */
    func resumePedometerUpdates()
    
    /**
     *  Called when the user starts tracking the activity, it calls begin or resume pedometer updates
     */
    func updatePedometer()
    
    /**
     *  Called when the user finishes tracking the activity
     */
    func stopPedometer()
    
    /**
     *  Called between constants periods of time to check for pedometer updates
     */
    func queryPedometerUpdates()
}

/**
 *  Handles the whole process of switching between different pool types during the activity (Walk/Run - Bike - Bus/Train)
 */
protocol SwitchDelegate {
    func showPoolSwitchAlert(text: String)
    func poolSwitchWalkRunSelected(alert: UIAlertAction!)
    func poolSwitchBikeSelected(alert: UIAlertAction!)
    func poolSwitchTrainBusSelected(alert: UIAlertAction!)
    func poolSwitchResume(alert: UIAlertAction!)
}

/**
 *  Handles the whole process of geolocation
 */
protocol ActivityLocationManagerDelegate : CLLocationManagerDelegate {
    func initLocationManager()
    func startLocationUpdates()
    func pauseLocationUpdates()
}

// MARK: - Class

class PoolViewController : ViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    // MARK: - Variables and Constants
    
    internal let kWalkBackgroundImage = "pool_background_walk"
    internal let kRunBackgroundImage = "pool_background_bike"
    internal let kTrainBackgroundImage = "pool_background_train"
    internal let kCarPoolBackgroundImage = "pool_background_carpool"
    
    internal let kMapSegueIdentifier = "mapSegue"
    
//    var player: AVAudioPlayer = AVAudioPlayer()
    
    var pool: Pool?
    var poolType: PoolType?
    var type: PoolTypeEnum?
    
    /**
     *  Indicates if the pool has already started
     */
    var hasPoolStarted = false
    
    /**
     *  Indicates if the pool has been paused at least once
     */
    var hasPausedAndResumedActivity = false
    
    /**
     *  Indicates the state of the activity in progress (Pause / Resume)
     */
    var isTimerTracking: Bool = false
    
    /**
     *  Handles all the location features
     */
    var locationManager: CLLocationManager!
    
    /**
     *  Collects all the information from the pool that must be sent to the API
     */
    var activity: Activity!
    
    /**
     *  Handles the whole step counting process (Walk pool only)
     */
    let pedoMeter = CMPedometer()
    var stepCount = 0
    var startDateToTrack: NSDate?
    var countingSteps : Bool?
    
    /*  
     *  This value regulates the speed in which the circular progress circle completes a whole round.
     *
     *  For Walk/Run and Bike pools, the circle completes a whole round after 1 mile.
     *  For Bus/Train and CarPools, the circle completes a whole round after 10 miles.
     */
    var circularProgressRoundOffset : Double = 0.0
    
    /*
     *  We keep a reference to the MapViewController, so that every time the user's location is updated, the new travel section is added to the map
     */
    var mapViewController : MapViewController?
}

