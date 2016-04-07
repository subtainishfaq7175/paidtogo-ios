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
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var finishButtonView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var circularProgressCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - Variables and Constants
    
    var type: Pools?
    
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
        
        switch type! {
        case .Walk: self.title = "walk_title".localize()
            break
        case .Bike:
            self.title = "bike_title".localize()
            break
        case .Train:
            self.title = "train_title".localize()
            break
        case .Car:
            self.title = "car_title".localize()
            break
        default:
            break
        }
        
    }
    
    private func initViews() {
        finishButtonView.round()
    }
    
}
