//
//  WellDoneViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 4/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class WellDoneViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var wellDoneLabel: UILabel!
    
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    
    @IBOutlet weak var backToHomebutton: UIButton!
    
    @IBOutlet weak var profileImageProportionalConstraint: NSLayoutConstraint!
    
    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var poolType: PoolType?
    var activityResponse: ActivityResponse?
    var activity: Activity?
    var pool: Pool?
    
    var screenshot : UIImage?
    
    // Quick Switch between Pools: if this var is not nil, it means the user hasn't pressed the "Finish" button but the "Switch Pool" button, on the right corner of the navigation of the previous screen
    var switchPoolType : PoolTypeEnum?
    
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
        
        self.populateFields()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
            case "shareSegue":
                let shareViewController = segue.destinationViewController as! ShareViewController
                shareViewController.type = self.type!
                
                shareViewController.screenshot = self.screenshot
                
                break
            case "leaderboardsSegue":
                let wdLeaderboardsViewController = segue.destinationViewController as! WDLeaderboardsViewController
                wdLeaderboardsViewController.type = self.type!
                wdLeaderboardsViewController.activity = self.activity!
                wdLeaderboardsViewController.poolType = self.poolType!
                wdLeaderboardsViewController.pool = self.pool!
            default:
                break
        }
        
    }
    
    // MARK: - Functions
    
    private func populateFields() {
        
        let currentUser = User.currentUser!

        if let currentProfilePicture = currentUser.profilePicture {
            
            //profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), options: .RefreshImageCache)
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), placeholder: nil, options: .RefreshImageCache, completion: { (img, url, type, stage, error) in
                
                // Once the user picture was loaded, we take a screenshot for share
                guard let screenshot = self.screenShotMethod() as UIImage? else {
                    print("NO SE PUDO SACAR EL SCREENSHOT")
                    return
                }
                
                self.screenshot = screenshot
                
            })
            
        }
        
        if var miles = activity?.milesTraveled {
            if miles == "" {
                miles = "0"
            }
            
            milesLabel.text = "\(miles) miles"
        }
        
        if var gas = activityResponse?.savedGas {
            if gas == "" {
                gas = "0"
            }
            
            gasLabel.text = "\(gas) gal"
        }
        
        if var co2 = activityResponse?.savedCo2 {
            if co2 == "" {
                co2 = "0"
            }
            
            co2Label.text = "\(co2) Metric tons"
        }
        
        if var cal = activityResponse?.savedCalories {
            if cal == "" {
                cal = "0 cal"
            }
            
            caloriesLabel.text = "\(cal) cal"
        }
        
        if let earnedMoney = activityResponse?.earnedMoney {
            earnedLabel.text = "$\(earnedMoney)*"
        } else {
            earnedLabel.text = "$0*"
        }
        
    }
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
  
        self.title = "menu_home".localize()
        
        setPoolColor(backgroundColorView, type: type!)
        
        if let switchPoolType = self.switchPoolType {
            self.backToHomebutton.setTitle("Choose next Pool!", forState: UIControlState.Normal)
        }
    }
    
    private func initViews() {
        profileImageView.roundWholeView()
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if screenHeight == 480.0 {
            if let font = UIFont(name: "OpenSans-Semibold", size: 24.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(profileImageProportionalConstraint, multiplier: 0.3)
            }
        } else if screenHeight == 568.0 {
            if let font = UIFont(name: "OpenSans-Semibold", size: 36.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(profileImageProportionalConstraint, multiplier: 0.38)
            }
        } else if screenHeight == 667.0 {
            if let font = UIFont(name: "OpenSans-Semibold", size: 40.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(profileImageProportionalConstraint, multiplier: 0.44)
            }
        } else {
            if let font = UIFont(name: "OpenSans-Semibold", size: 44.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(profileImageProportionalConstraint, multiplier: 0.48)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backToHome(sender: AnyObject) {
        if let mainVC = self.presentingViewController as? MainViewController {
            if let navVc = mainVC.contentViewController as? UINavigationController {
                if let switchPoolType = self.switchPoolType {
                    if let poolsVc = navVc.viewControllers[1] as? PoolsViewController {
                        
                        DataProvider.sharedInstance.getPoolType(switchPoolType, completion: { (poolType, error) in
                            poolsVc.poolType = poolType
                            poolsVc.type = switchPoolType
                            poolsVc.openPools = [Pool]()
                            poolsVc.closedPools = [Pool]()
                            poolsVc.quickSwitchPool = true
//                            poolsVc.openPoolsTableView.reloadData()
                            navVc.popToViewController(poolsVc, animated: true)
                            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                        })
                        
                    }
                } else {
                    navVc.popToRootViewControllerAnimated(true)
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
//        self.presentHomeViewController()
    }
    
    @IBAction func leaderboardsButtonAction(sender: AnyObject) {
        let leaderboardsVC = StoryboardRouter.initialLeaderboardsViewController()
        
        leaderboardsVC.cameFromWellDoneViewController = true
        leaderboardsVC.poolId = self.pool!.internalIdentifier!
        
        self.navigationController?.pushViewController(leaderboardsVC, animated: true)
        
//        leaderboardsVC.type = self.type!
//        leaderboardsVC.activity = self.activity!
//        leaderboardsVC.poolType = self.poolType!
//        leaderboardsVC.pool = self.pool!
    }
    
    // MARK:- Helpers
    
    func screenShotMethod() -> UIImage? {
        //let layer = UIApplication.sharedApplication().keyWindow!.layer
        let layer = self.backgroundColorView.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
}
