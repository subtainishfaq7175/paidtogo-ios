//
//  PoolDetailViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 20/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftDate

class PoolDetailViewController: ViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var enterPoolButton: LocalizableButton!
    
    @IBOutlet weak var headerTitleLabel: LocalizableLabel!    
        
    @IBOutlet weak var poolTitleLabel: UILabel!
    @IBOutlet weak var earnedMoneyPerMileLabel: UILabel!
    @IBOutlet weak var limitPerDayLabel: UILabel!
    @IBOutlet weak var limitPerMonthLabel: UILabel!
    
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var backgroundContentView: UIView!
    
    @IBOutlet weak var bannerBottomBorderView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var poolIconImageView: UIImageView!
    
    // MARK: - Variables and constants
    
    var pool : Pool?
    var typeEnum : PoolTypeEnum?
    var poolType : PoolType?
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
        
        ActivityManager.sharedInstance.resetActivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
    }
    
    private func configureView() {
        setPoolColorAndTitle(backgroundColorView, typeEnum: typeEnum!, type: poolType!)
        
        backgroundImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        setBorderToViewAndRoundVeryLittle(poolIconImageView, color: UIColor(rgba: poolType!.color!).CGColor)
        
        bannerBottomBorderView.backgroundColor = UIColor(rgba: poolType!.color!)
        
        configureContinueButton()
        
        if let iconImage = pool?.iconPhoto as String? {
            if !iconImage.isEmpty {
                poolIconImageView.yy_setImageWithURL(NSURL(string: (iconImage)), options: .ShowNetworkActivity)
            }
        }
        
        if let bannerImage = pool?.banner as String? {
            if !bannerImage.isEmpty {
                bannerImageView.yy_setImageWithURL(NSURL(string: (bannerImage)), options: .ShowNetworkActivity)
            }
        }
        
        if let earnedMoneyPerMile = pool?.earnedMoneyPerMile {
            earnedMoneyPerMileLabel.text = earnedMoneyPerMileLabel.text! + "$" + earnedMoneyPerMile
        }
        
        if let limitPerDay = pool?.limitPerDay {
            limitPerDayLabel.text = limitPerDayLabel.text! + "$" + limitPerDay
        }
        
        if let limitPerMonth = pool?.limitPerMonth {
            limitPerMonthLabel.text = limitPerMonthLabel.text! + "$" + limitPerMonth
        }
        
        if let endDate = pool?.endDateTime {
            dateLabel.text = NSDate.getDateStringWithFormatddMMyyyy(endDate)
        }
        
        if let poolTitle = pool?.name {
            poolTitleLabel.text = poolTitle
        }
    }
    
    private func configureContinueButton() {
        enterPoolButton.roundVeryLittleForHeight(50.0)
        
        guard let poolStartDateString = pool?.startDateTime else {
            return
        }
        
        let poolStartDate = NSDate.getDateWithFormatddMMyyyy(poolStartDateString)
        
        if !poolStartDate.isDatePreviousToCurrentDate() {
            // The pool hasn't started yet
            enterPoolButton.setTitle("Coming soon...", forState: UIControlState.Normal)
            enterPoolButton.alpha = CGFloat(0.3)
            enterPoolButton.enabled = false
            
            dateTitleLabel.text = "Begins on:"
            dateLabel.text = NSDate.getDateStringWithFormatddMMyyyy(poolStartDateString)
            
        } else {
            // The pool has started
            enterPoolButton.setTitle("Continue", forState: UIControlState.Normal)
            enterPoolButton.alpha = CGFloat(1)
            enterPoolButton.enabled = true
            
            dateTitleLabel.text = "Ends on:"
            dateLabel.text = NSDate.getDateStringWithFormatddMMyyyy((pool?.endDateTime)!)
        }
    }
    
    private func showAntiCheatViewController(pool: Pool) {
        let vc = StoryboardRouter.homeStoryboard().instantiateViewControllerWithIdentifier("AnticheatViewController") as! AntiCheatViewController
        vc.pool = pool
        self.showViewController(vc, sender: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func btnContinuePressed(sender: AnyObject) {
        guard let pool = self.pool else {
            return
        }
        
        ActivityManager.sharedInstance.poolId = pool.internalIdentifier!
        
        switch self.typeEnum! {
        case .Train:
            showAntiCheatViewController(pool)
            break
        case .Car:
            
            let carViewController = StoryboardRouter.homeStoryboard().instantiateViewControllerWithIdentifier("CarPoolInviteViewController") as? CarPoolInviteViewController
            carViewController!.type = self.typeEnum
            carViewController!.poolType = self.poolType
            carViewController!.pool = self.pool
            self.showViewController(carViewController!, sender: nil)
            
            break
        default:
            showPoolViewController(self.typeEnum!, poolType: self.poolType!, pool: pool, sender: nil)
            break
        }
    }
    
    @IBAction func btnTermsAndConditionsPressed(sender: AnyObject) {
        let destinationVC = StoryboardRouter.termsAndConditionsViewController()
        destinationVC.poolType = self.poolType
        self.showViewController(destinationVC, sender: nil)
    }
}
