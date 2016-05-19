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
    
    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var activityResponse: ActivityResponse?
    
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
        
        let currentUser = User.currentUser!
        
        
        if let currentProfilePicture = currentUser.profilePicture {
            
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), options: .RefreshImageCache)
            
        }
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
        self.presentHomeViewController()
    }
    
}