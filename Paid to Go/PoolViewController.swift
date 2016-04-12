//
//  PoolViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 4/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class PoolViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - Variables and Constants
    
    var type: Pools?
    
    var hasPoolStarted = false

    
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
        setNavigationBarVisible(true)
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        
        setPoolTitle(self.type!)
        setPoolColor(self.actionButtonView, type: self.type!)
    }
    
    private func initViews() {
        actionButtonView.round()
    }
    
    // MARK: - Actions
    
    
    @IBAction func actionButtonAction(sender: AnyObject) {
        if !hasPoolStarted {
            hasPoolStarted = true
            actionButton.setTitle("action_finish".localize(), forState: UIControlState.Normal)
        } else {
            let poolDoneNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("poolDoneNavigationController") as! UINavigationController
            let wellDoneViewController = poolDoneNavigationController.viewControllers[0] as! WellDoneViewController
            wellDoneViewController.type = self.type

            self.presentViewController(poolDoneNavigationController, animated: true, completion: nil)
            
        }
    }
    
}
