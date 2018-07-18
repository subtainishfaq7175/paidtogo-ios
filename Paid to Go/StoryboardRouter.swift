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
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static func homeStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Home", bundle: Bundle.main)
    }
    
    static func menuStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Menu", bundle: Bundle.main)
    }
    
    static func leaderboardsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Leaderboards", bundle: Bundle.main)
    }
    
    static func profileStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: Bundle.main)
    }
    
    static func activityStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Activity", bundle: Bundle.main)
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
    
    static func homeViewController() -> HomeViewController {
        return homeStoryboard().instantiateViewController(withIdentifier:IdentifierConstants.idConsShared.HOME_VC) as! HomeViewController
    }
    
    static func initialSignupViewController() -> SignupViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
    }
    
    static func initialProfileViewController() -> ProfileViewController {
        return profileStoryboard().instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
    
    static func initialLeaderboardsViewController() -> LeaderboardsViewController {
        return leaderboardsStoryboard().instantiateViewController(withIdentifier: "LeaderboardsViewController") as! LeaderboardsViewController
    }
    
//    static func leaderboardsMainViewController() -> UIViewController {
//        return leaderboardsStoryboard().instantiateInitialViewController()!
//    }
    
    static func termsAndConditionsViewController() -> TermsAndConditionsViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditionsViewController
    }
    
    static func termsAndConditionsNavigationController() -> UINavigationController {
        return mainStoryboard().instantiateViewController(withIdentifier: "TermsAndConditionsNavigationController") as! UINavigationController
    }
    
    static func poolDetailViewController() -> PoolDetailViewController {
        return homeStoryboard().instantiateViewController(withIdentifier: "PoolDetailViewController") as! PoolDetailViewController
    }
    
    static func nationalPoolsViewController() -> NationalPoolsViewController {
        return homeStoryboard().instantiateViewController(withIdentifier: "NationalPoolsViewController") as! NationalPoolsViewController
    }
    
    static func activitySponserViewController() -> ActivitySponsorViewController {
        let viewController = homeStoryboard().instantiateViewController(withIdentifier: "ActivitySponsorViewController") as! ActivitySponsorViewController
        
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
//        viewController.definesPresentationContext = true
        return viewController
    }
    
    static func activityMoniteringViewController() -> ActivityMoniteringViewController {
        return activityStoryboard().instantiateViewController(withIdentifier: "ActivityMoniteringViewController") as! ActivityMoniteringViewController
    }
    
        
}
