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

class PoolViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    // MARK: - Variables and Constants
    
    var type: PoolType?
    var hasPoolStarted = false
    var isTimerTracking: Bool = false
    var timer = NSTimer()
    var trackNumber = 0
    
    
    // MARK: -  Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initLayout()
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
        //        circularProgressView.animateFromAngle(0, toAngle: 360, duration: 10, relativeDuration: true, completion: nil)
        trackNumber = trackNumber + 1
        circularProgressView.angle = trackNumber * 360 / 100
        progressLabel.text = "\(trackNumber )"
        
        if trackNumber == 100{
            self.pauseButton.hidden = true
            timer.invalidate()
        }
        isTimerTracking = true
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func toggle(sender: AnyObject) {
        if isTimerTracking {
            isTimerTracking = false
            timer.invalidate()
            pauseButton.setTitle("Resume", forState: UIControlState.Normal)
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(startTracking), userInfo: nil, repeats: true)
            timer.fire()
            isTimerTracking = true
            pauseButton.setTitle("Pause", forState: UIControlState.Normal)
   }
        
    }
    
    @IBAction func switchBetweenPools(sender: AnyObject) {
        
    }
    
    @IBAction func track(sender: AnyObject) {
        if !hasPoolStarted {
            hasPoolStarted = true
            actionButton.setTitle("action_finish".localize(), forState: UIControlState.Normal)
            setPoolColor(self.actionButtonView, type: self.type!)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(startTracking), userInfo: nil, repeats: true)
            timer.fire()
            pauseButton.hidden = false
            
        } else {
            let poolDoneNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("poolDoneNavigationController") as! UINavigationController
            let wellDoneViewController = poolDoneNavigationController.viewControllers[0] as! WellDoneViewController
            wellDoneViewController.type = self.type
            
            self.presentViewController(poolDoneNavigationController, animated: true, completion: nil)
            
        }
    }
    
}
