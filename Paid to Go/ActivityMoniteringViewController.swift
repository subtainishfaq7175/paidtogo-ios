//
//  ActivityMoniteringViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 6/28/18.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import KDCircularProgress

class ActivityMoniteringViewController: MenuContentViewController, ActivityMoniteringManagerDelegate {

    // MARK: - IBOutlets -
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
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
    var isCycling: Bool = false
    
    var activity = ManualActivity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
        ActivityMoniteringManager.sharedManager.delegate = self
        actionButtonView.layer.cornerRadius = (actionButtonView.bounds.height / 2) - 2
        bannerView.layer.cornerRadius = (bannerView.bounds.height / 2)
        bannerView.layer.borderWidth = 2.0
        bannerView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Settings.shared.isAutoTrackingOn {
            actionButton.isHidden = true
            actionButtonView.isHidden = true
            
            let startOftheDay = Calendar.current.startOfDay(for: Date())
            ActivityMoniteringManager.sharedManager.trackRunning(fromDate: startOftheDay)
        } else {
            actionButton.isHidden = false
            actionButtonView.isHidden = false
            ActivityMoniteringManager.sharedManager.stopTracking()
          // stop updates
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action Methods
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        showActivitySelectionSheet()
        activity.startDate = Date()
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        setupUIForStart(true)
        ActivityMoniteringManager.sharedManager.stopTracking()
        activity.endDate = Date()
        ActivityMoniteringManager.sharedManager.save(activity: activity)
        activity = ManualActivity()
    }
    
    
    //MARK: - Private Methods
    
    private func setupUIForStart(_ isStart: Bool) {
        if !isStart {
            actionButton.isHidden = true
            actionButtonView.isHidden = true
            pauseButton.isHidden = false
        } else {
            actionButtonView.isHidden = false
            actionButton.isHidden = false
            pauseButton.isHidden = true
        }
    }
    
    private func showActivitySelectionSheet() {
        let alertController = UIAlertController(title: "Activities", message: "Select an Activity to start.", preferredStyle: .actionSheet)
        
        let walkingAction = UIAlertAction(title: "Walking", style: .default) { walkingAction in
            self.stepCountLabel.isHidden = false
            self.clearUI()
            ActivityMoniteringManager.sharedManager.trackWalking()
            self.activity.type = .walkingRunning
        }
        let runningAction = UIAlertAction(title: "Running", style: .default) { runningAction in
            self.stepCountLabel.isHidden = false
            self.clearUI()
            ActivityMoniteringManager.sharedManager.trackRunning()
            self.activity.type = .walkingRunning
        }
        let cyclingAction = UIAlertAction(title: "Cycling", style: .default) { cyclingAction in
            self.stepCountLabel.isHidden = true
            ActivityMoniteringManager.sharedManager.trackCycling()
            self.activity.type = .cycling
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alertController.addAction(walkingAction)
        alertController.addAction(runningAction)
        alertController.addAction(cyclingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func clearUI() {
        stepCountLabel.text = "Steps: 0"
        progressLabel.text = "0"
        setupUIForStart(false)
    }
    
    private func updateWalkingAndRunning(distance: Double, steps: NSNumber) {
        DispatchQueue.main.async {
            let dis = String(format: "%.2f", distance)
            self.stepCountLabel.text = "Steps: \(steps)"
            self.progressLabel.text = "\(dis)"
            
            var distancets = distance
            distancets.round(.toNearestOrAwayFromZero)
            distancets =  distance - distancets
            let angle = distancets * 360
            
            self.circularProgressView.angle = angle
        }
        
        activity.steps = steps.intValue
        activity.milesTraveled = distance
    }
    
    
    //MARK: - ActivityMoniteringManagerDelegate Methods
    
    func didWalk(Steps steps: NSNumber, Distance distance:Double) {
        updateWalkingAndRunning(distance: distance, steps: steps)
        
    }
    
    func didRun(Steps steps: NSNumber, Distance distance:Double) {
        updateWalkingAndRunning(distance: distance, steps: steps)
    
    }
    
    func didCycling(activity: ManualActivity) {
        self.activity = activity
        updateWalkingAndRunning(distance: activity.milesTraveled, steps: 0)
    }
    
    func didCycle(Speed speed: Double) {
        
    }
    
    func didCycle(Distance distance: Double) {
        
    }
    
    func didDetectActivity(Activity activity: NSString) {
        
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
