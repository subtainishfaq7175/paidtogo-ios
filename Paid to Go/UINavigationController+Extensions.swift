//
//  UINavigationController+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 7/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: () -> ()) {
        pushViewController(viewController, animated: animated)
        
        if let coordinator = transitionCoordinator() where animated {
            coordinator.animateAlongsideTransition(nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: () -> ()) {
        popViewControllerAnimated(animated)
        
        if let coordinator = transitionCoordinator() where animated {
            coordinator.animateAlongsideTransition(nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}