//
//  ProfileViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 22/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: MenuContentViewController {
    
    // MARK: - Outlets
    
    
    // MARK: - Variables and Constants
    
    var signupViewController: SignupViewController!
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.signupViewController = StoryboardRouter.initialSignupViewController()
        self.addChildViewController(signupViewController)
        self.view.addSubview(signupViewController.view)
        
        self.signupViewController.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        self.signupViewController.termsAndConditionsSwitch.hidden = true
        self.signupViewController.termsAndConditionsButton.hidden = true
        self.signupViewController.signupButton.setTitle("Ok", forState: .Normal)
        
//        This is to remove the target that will be added on the button for submit the signup data
//        self.signupViewController.signupButton.removeTarget(self.signupViewController, action: "signupAction:", forControlEvents: .TouchUpInside)
        
        self.signupViewController.signupButton.addTarget(self, action: "submitAction:", forControlEvents: .TouchUpInside)
        
        setNavigationBarVisible(true)
        self.title = "Profile"
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    // MARK: - Functions
    
    
    
    // MARK: - Actions
    
    func submitAction(sender: AnyObject?){
        log.debug("Profile changes submited")
    }
    
    
}