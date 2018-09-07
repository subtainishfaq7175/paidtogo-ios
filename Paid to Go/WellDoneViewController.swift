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
    @IBOutlet weak var activityTypeLabel: UILabel!
    
    @IBOutlet weak var backToHomebutton: UIButton!
    
    @IBOutlet weak var profileImageProportionalConstraint: NSLayoutConstraint!
    
    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var poolType: PoolType?
    var activityResponse: ActivityNotification?
    var activity : ManualActivity?
    var pool: Pool?
    var activityType = ActivityTypeEnum.walkingRunning
    
    var screenshot : UIImage?
    
    // Quick Switch between Pools: if this var is not nil, it means the user hasn't pressed the "Finish" button but the "Switch Pool" button, on the right corner of the navigation of the previous screen
    var switchPoolType : PoolTypeEnum?
    
    // MARK: -  Super
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        NotificationCenter.default.post(name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_WELLDONE_SCREEN_APPEARED), object: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier! {
//        case "shareSegue":
//            let shareViewController = segue.destination as! ShareViewController
//            shareViewController.type = self.type!
//
//            shareViewController.screenshot = self.screenshot
//
//            break
//        case "leaderboardsSegue":
//            let wdLeaderboardsViewController = segue.destination as! WDLeaderboardsViewController
//            wdLeaderboardsViewController.type = self.type!
//            wdLeaderboardsViewController.activity = self.activity!
//            wdLeaderboardsViewController.poolType = self.poolType!
//            wdLeaderboardsViewController.pool = self.pool!
//        default:
//            break
//        }
    }

    
    // MARK: - Functions
    
    private func populateFields() {
        
        let currentUser = User.currentUser!

        if let currentProfilePicture = currentUser.profilePicture {
            
            //profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), options: .RefreshImageCache)
            profileImageView.yy_setImage(with: URL(string: currentProfilePicture), placeholder: UIImage(named: "ic_profile_placeholder"), options: .refreshImageCache, completion: { (img, url, type, stage, error) in
                
                // Once the user picture was loaded, we take a screenshot for share
                guard let screenshot = self.screenShotMethod() as UIImage? else {
                    print("NO SE PUDO SACAR EL SCREENSHOT")
                    return
                }
                
                self.screenshot = screenshot
                
            })
            
        }
        
        updateLabelsFromActivityResponse()
    }
    
    private func updateLabelsFromActivityResponse() {
        if let miles = activityResponse?.milesTraveled {
            if miles == 0.0 {
                milesLabel.text = "0 miles"
            } else {
                milesLabel.text = String(format: "%.2f", miles) + " miles"
            }
        }
        
        if let gas = activityResponse?.savedGas {
            if gas == 0.0 {
                gasLabel.text = "0 gal"
            } else {
                gasLabel.text = String(format: "%.2f", gas) + " gal"
            }
        } else {
            gasLabel.text = "0 gal"
        }
        
        if let co2 = activityResponse?.savedCo2 {
            if co2 == 0.0 {
                co2Label.text = "0 Metric tons"
            } else {
                co2Label.text = String(format: "%.2f", co2) + " Metric tons"
            }
        } else {
            co2Label.text = "0 Metric tons"
        }
        
        if let cal = activityResponse?.savedCalories {
            if cal == 0.0 {
                caloriesLabel.text = "0 cal"
            } else {
                caloriesLabel.text = String(format: "%.2f", cal) + " cal"
            }
        } else {
            caloriesLabel.text = "0 cal"
        }
        
        if let earnedMoney = activityResponse?.totalSteps {
            earnedLabel.text = "\(earnedMoney) steps"
        } else {
            earnedLabel.text = "0 steps"
        }
    }
    
    private func updateLabelsFromActivity() {
        if let miles = activity?.milesTraveled {
            if miles == 0.0 {
                milesLabel.text = "0 miles"
            } else {
                 milesLabel.text = String(format: "%.2f", miles) + " miles"
            }
        }
        
        if let gas = activity?.traffic {
            if gas == 0.0 {
                gasLabel.text = "0 gal"
            } else {
                gasLabel.text = String(format: "%.2f", gas) + " gal"
            }
        } else {
            gasLabel.text = "0 gal"
        }
        
        if let co2 = activity?.co2Offset {
            if co2 == 0.0 {
                co2Label.text = "0 Metric tons"
            } else {
                co2Label.text = String(format: "%.2f", co2) + " Metric tons"
            }
        } else {
            co2Label.text = "0 Metric tons"
        }
        
        if let cal = activity?.calories {
            if cal == 0.0 {
                caloriesLabel.text = "0 cal"
            } else {
                caloriesLabel.text = String(format: "%.2f", cal) + " cal"
            }
        } else {
            caloriesLabel.text = "0 cal"
        }
        
        if let steps = activity?.steps {
            earnedLabel.text = "\(steps) steps"
        } else {
            earnedLabel.text = "0 steps"
        }
    }
    
    private func initLayout() {
        setNavigationBarVisible(visible: true)
        clearNavigationBarcolor()
  
        self.title = "menu_home".localize()
        
//        setPoolColor(view: backgroundColorView, type: type!)
        
//        if let switchPoolType = self.switchPoolType {
//            self.backToHomebutton.setTitle("Choose next Pool!", for: UIControlState.normal)
//        }
    }
    
    private func initViews() {
        profileImageView.roundWholeView()
        
        let screenHeight = UIScreen.main.bounds.size.height
        
        if screenHeight == 480.0 {
            if let font = UIFont(name: "OpenSans-Semibold", size: 24.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(constraint: profileImageProportionalConstraint, multiplier: 0.3)
            }
        } else if screenHeight == 568.0 {
            if let font = UIFont(name: "OpenSans-Semibold", size: 36.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(constraint: profileImageProportionalConstraint, multiplier: 0.38)
            }
        } else if screenHeight == 667.0 {
            if let font = UIFont(name: "OpenSans-Semibold", size: 40.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(constraint: profileImageProportionalConstraint, multiplier: 0.44)
            }
        } else {
            if let font = UIFont(name: "OpenSans-Semibold", size: 44.0) {
                wellDoneLabel.font = font
                profileImageProportionalConstraint = NSLayoutConstraint.changeMultiplier(constraint: profileImageProportionalConstraint, multiplier: 0.48)
            }
        }
        
        var activityType = "Walk/Run/Bike"
        
        
        switch self.activityType {
        case .walkingRunning:
            activityType = "Walk/Run"
        case .cycling:
            activityType = "Bike"
        case .workout:
            activityType = "Workout"
        case .none:
            activityType = "Walk/Run/Bike"
            
        }
        activityTypeLabel.text = activityType
    }
    
    // MARK: - Actions
    
    @IBAction func backToHome(sender: AnyObject) {
        if let mainVC = self.presentingViewController as? MainViewController {
            if let navVc = mainVC.contentViewController as? UINavigationController {
                if let switchPoolType = self.switchPoolType {
                    if let poolsVc = navVc.viewControllers[1] as? PoolsViewController {
                        
                        DataProvider.sharedInstance.getPoolType(poolTypeEnum: switchPoolType, completion: { (poolType, error) in
                            poolsVc.poolType = poolType
                            poolsVc.type = switchPoolType
                            poolsVc.openPools = [Pool]()
                            poolsVc.closedPools = [Pool]()
                            poolsVc.quickSwitchPool = true
//                            poolsVc.openPoolsTableView.reloadData()
                            navVc.popToViewController(poolsVc, animated: true)
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        })
                        
                    }
                } else {
                    navVc.popToRootViewController(animated: true)
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
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
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
}
