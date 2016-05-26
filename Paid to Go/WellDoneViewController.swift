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
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var trafficLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    
    
    
    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var poolType: PoolType?
    var activityResponse: ActivityResponse?
    var activity: Activity?
    
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
                break
            case "leaderboardsSegue":
                let wdLeaderboardsViewController = segue.destinationViewController as! WDLeaderboardsViewController
                wdLeaderboardsViewController.type = self.type!
            default:
                break
        }
        
    }
    
    // MARK: - Functions
    
    private func populateFields() {
        
        let currentUser = User.currentUser!

        
        if let currentProfilePicture = currentUser.profilePicture {
            
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), options: .RefreshImageCache)
            
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
        
    }
    
    
    private func initViews() {
        profileImageView.roundWholeView()
    }
    
    // MARK: - Actions
    
    
    @IBAction func backToHome(sender: AnyObject) {
        if let mainVC = self.presentingViewController as? MainViewController {
            if let navVc = mainVC.contentViewController as? UINavigationController {
                navVc.popToRootViewControllerAnimated(true)
            }
        }
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//        self.presentHomeViewController()
    }
    
}