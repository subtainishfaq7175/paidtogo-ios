//
//  StoryboardRouter.swift
//  HHA
//
//  Created by Fernando Ortiz on 11/11/15.
//  Copyright © 2015 Gonzalo Alu. All rights reserved.
//

import Foundation
import UIKit

/*
Class used to get UIViewControllers and config them previously

*/
class StoryboardRouter {
    
    // MARK: - Storyboards
    static func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    static func homeStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Home", bundle: NSBundle.mainBundle())
    }
    
    static func menuStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Menu", bundle: NSBundle.mainBundle())
    }
    
    static func leaderboardsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Leaderboards", bundle: NSBundle.mainBundle())
    }
    
    static func profileStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: NSBundle.mainBundle())
    }
    
    // MARK: - View Controllers
    
//    static func homeMainViewController() -> UIViewController {
//        return homeStoryboard().instantiateInitialViewController()!
//    }
    
//    static func initialMainViewController() -> UIViewController {
//        return mainStoryboard().instantiateInitialViewController()!
//    }
    
    static func menuMainViewController() -> UIViewController {
        return menuStoryboard().instantiateInitialViewController()!
    }
    
    static func initialSignupViewController() -> SignupViewController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
    }
    
    static func initialProfileViewController() -> ProfileViewController {
        return profileStoryboard().instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
    }
    
    static func initialLeaderboardsViewController() -> LeaderboardsViewController {
        return leaderboardsStoryboard().instantiateViewControllerWithIdentifier("LeaderboardsViewController") as! LeaderboardsViewController
    }
    
//    static func leaderboardsMainViewController() -> UIViewController {
//        return leaderboardsStoryboard().instantiateInitialViewController()!
//    }
    
    static func termsAndConditionsViewController() -> TermsAndConditionsViewController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TermsAndConditions") as! TermsAndConditionsViewController
    }
    
    static func termsAndConditionsNavigationController() -> UINavigationController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TermsAndConditionsNavigationController") as! UINavigationController
    }
    
    static func poolDetailViewController() -> PoolDetailViewController {
        return homeStoryboard().instantiateViewControllerWithIdentifier("PoolDetailViewController") as! PoolDetailViewController
    }
    
    static func nationalPoolsViewController() -> NationalPoolsViewController {
        return homeStoryboard().instantiateViewControllerWithIdentifier("NationalPoolsViewController") as! NationalPoolsViewController
    }
        
}
