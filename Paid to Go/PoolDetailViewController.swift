//
//  PoolDetailViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 20/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import CoreLocation

class PoolDetailViewController: ViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var enterPoolButton: LocalizableButton!
    
    @IBOutlet weak var headerTitleLabel: LocalizableLabel!    
    @IBOutlet weak var earnedMoneyLabel: UILabel!
    
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var backgroundContentView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Variables and constants
    
    var pool : Pool?
    var typeEnum : PoolTypeEnum?
    var poolType : PoolType?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
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
    
    func configureView() {
        setPoolColorAndTitle(backgroundColorView, typeEnum: typeEnum!, type: poolType!)
        self.backgroundImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
        enterPoolButton.roundVeryLittleForHeight(50.0)
        
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
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
        
        ActivityManager.sharedInstance.endLatitude = Double(pool.destinationLatitude!)!
        ActivityManager.sharedInstance.endLongitude = Double(pool.destinationLongitude!)!
        ActivityManager.sharedInstance.milesCounter = 0.0
        
        ActivityManager.sharedInstance.endLocation = CLLocation(latitude: Double(pool.destinationLatitude!)!, longitude: Double(pool.destinationLongitude!)!)
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
