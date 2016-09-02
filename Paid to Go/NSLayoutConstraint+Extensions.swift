//
//  NSLayoutConstraint+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 1/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    static func changeMultiplier(constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant)
        
        newConstraint.priority = constraint.priority
        
        NSLayoutConstraint.deactivateConstraints([constraint])
        NSLayoutConstraint.activateConstraints([newConstraint])
        
        return newConstraint
    }
}
