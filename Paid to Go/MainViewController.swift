//
//  MainViewController.swift
//  Care4
//
//  Created by Fernando Ortiz on 1/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import REFrostedViewController
import RainbowNavigation

class MainViewController: REFrostedViewController {
    
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // menu configuration
        self.panGestureEnabled = true
        
        if let menuController = storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as? MenuViewController {
        menuController.delegate = self
        self.menuViewController = menuController
        
        menuController.setMainViewController(self)
        
        self.direction = .Left
            
        }
        
        
    }
    
    
}

// MARK: - MenuViewControllerDelegate
extension MainViewController: MenuViewControllerDelegate {
    func setMenuContentViewController(controller: UIViewController) {
        self.contentViewController = controller
        
        if let controllerNavigation = controller as? UINavigationController {
            if let menuContentController = controllerNavigation.topViewController as? MenuContentViewController {
                menuContentController.menuController = self
            }
        }
        self.hideMenuViewController()
    }
}
