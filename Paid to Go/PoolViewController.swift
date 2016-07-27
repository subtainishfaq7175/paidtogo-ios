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

/**
 *  Handles the step counting process
 */
protocol PedometerDelegate {
    func beginPedometerUpdates()
    func pausePedometerUpdates()
    func resumePedometerUpdates()
    func updatePedometer()
    func queryPedometerUpdates()
}

/**
 *  Handles the whole activity tracking process
 */
protocol TrackDelegate {
    func startTracking()
    func pauseTracking()
    func endTracking()
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
    var locationdCoordinate: CLLocationCoordinate2D?
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
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    var distanceToFinalDestination: Double = 0.0
    
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

