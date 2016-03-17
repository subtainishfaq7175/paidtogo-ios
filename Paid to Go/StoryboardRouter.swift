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
    
    
    
    // MARK: - View Controllers
    
    static func homeMainViewController() -> UIViewController {
        return homeStoryboard().instantiateInitialViewController()!
    }
    
    static func initialMainViewController() -> UIViewController {
        return mainStoryboard().instantiateInitialViewController()!
    }
    
        
}