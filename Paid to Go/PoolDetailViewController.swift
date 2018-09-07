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

    // MARK: - Outlets -
    
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
    
    // MARK: - Attributes -
    
    var pool : Pool?
    var typeEnum : PoolTypeEnum?
    var poolType : PoolType?
    
    // MARK: - View Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
        
        ActivityManager.sharedInstance.resetActivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBorderToView(view: headerTitleLabel, color: CustomColors.NavbarTintColor().cgColor)
        do {
            let col = try UIColor(rgba_throws:poolType!.color! )
            setBorderToViewAndRoundVeryLittle(view: poolIconImageView, color: col.cgColor)

        }catch{
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods -
    
    private func initLayout() {
        setNavigationBarVisible(visible: true)
        clearNavigationBarcolor()
        setPoolColorAndTitle(view: backgroundColorView, typeEnum: typeEnum!, type: poolType!)
    }
    
    private func configureView() {
//        setPoolColorAndTitle(backgroundColorView, typeEnum: typeEnum!, type: poolType!)
        
        backgroundImageView.yy_setImage(with: URL(string: (poolType?.backgroundPicture)!), options: .showNetworkActivity)
        
//        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
//        setBorderToViewAndRoundVeryLittle(poolIconImageView, color: UIColor(rgba: poolType!.color!).CGColor)
        do {
            bannerBottomBorderView.backgroundColor = try UIColor(rgba_throws: poolType!.color!)

        }catch{
            
        }
        
        configureContinueButton()
        
        if let iconImage = pool?.iconPhoto as String? {
            if !iconImage.isEmpty {
                poolIconImageView.yy_setImage(with: URL(string: (iconImage)), options: .showNetworkActivity)
            }
        }
        
        if let bannerImage = pool?.banner as String? {
            if !bannerImage.isEmpty {
                bannerImageView.yy_setImage(with: URL(string: (bannerImage)), options: .showNetworkActivity)
            }
        }
        
        if let earnedMoneyPerMile = pool?.earnedMoneyPerMile {
            earnedMoneyPerMileLabel.text = earnedMoneyPerMileLabel.text! + "$" + String(format: "%.2f", earnedMoneyPerMile)
        }
        
        if let limitPerDay = pool?.limitPerDay {
            limitPerDayLabel.text = limitPerDayLabel.text! + "$" + limitPerDay
        }
        
        if let limitPerMonth = pool?.limitPerMonth {
            limitPerMonthLabel.text = limitPerMonthLabel.text! + "$" + limitPerMonth
        }
        
        if let endDate = pool?.endDateTime {
            dateLabel.text = Date.getDateStringWithFormatddMMyyyy(dateString: endDate)
        }
        
        if let poolTitle = pool?.name {
            poolTitleLabel.text = poolTitle
        }
    }
    
    private func configureContinueButton() {
        enterPoolButton.roundVeryLittleForHeight(height: 50.0)
        
        guard let poolStartDateString = pool?.startDateTime else {
            return
        }
        
        let poolStartDate = Date.getDateWithFormatddMMyyyy(dateString: poolStartDateString)
        
        if !poolStartDate.isDatePreviousToCurrentDate() {
            // The pool hasn't started yet
            enterPoolButton.setTitle("Coming soon...", for: UIControlState.normal)
            enterPoolButton.alpha = CGFloat(0.3)
            enterPoolButton.isEnabled = false
            
            dateTitleLabel.text = "Begins on:"
            dateLabel.text = Date.getDateStringWithFormatddMMyyyy(dateString: poolStartDateString)
            
        } else {
            // The pool has started
            enterPoolButton.setTitle("Continue", for: UIControlState.normal)
            enterPoolButton.alpha = CGFloat(1)
            enterPoolButton.isEnabled = true
            
            dateTitleLabel.text = "Ends on:"
            dateLabel.text = Date.getDateStringWithFormatddMMyyyy(dateString: (pool?.endDateTime)!)
        }
    }
    
    private func showAntiCheatViewController(pool: Pool) {
        let vc = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "AnticheatViewController") as! AntiCheatViewController
        vc.pool = pool
        self.show(vc, sender: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func btnSponsorPressed(sender: AnyObject) {
        
        if let sponsorURL = pool?.sponsorLink {
            let url : URL = URL(string: sponsorURL)!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnContinuePressed(sender: AnyObject) {
        guard let pool = self.pool else {
            return
        }
        
//        ActivityManager.sharedInstance.poolId = pool.internalIdentifier!
        
        switch self.typeEnum! {
        case .Train:
            showAntiCheatViewController(pool: pool)
            break
        case .Car:
            
            let carViewController = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "CarPoolInviteViewController") as! CarPoolInviteViewController
            carViewController.type = self.typeEnum
            carViewController.poolType = self.poolType
            carViewController.pool = self.pool
            self.show(carViewController, sender: nil)
            
            break
        default:
            showPoolViewController(type: self.typeEnum!, poolType: self.poolType!, pool: pool, sender: nil)
            break
        }
    }
    
    @IBAction func btnTermsAndConditionsPressed(sender: AnyObject) {
        let termsNavController = StoryboardRouter.termsAndConditionsNavigationController()
        let termsVC = termsNavController.viewControllers.first as! TermsAndConditionsViewController
        termsVC.poolType = self.poolType
        termsVC.termsAndConditionsText = self.pool?.termsAndConditions
        self.present(termsNavController, animated: true, completion: nil)
        
//        let destinationVC = StoryboardRouter.termsAndConditionsViewController()
//        destinationVC.poolType = self.poolType
//        destinationVC.termsAndConditionsText = self.pool?.termsAndConditions
//        self.showViewController(destinationVC, sender: nil)
    }
}
