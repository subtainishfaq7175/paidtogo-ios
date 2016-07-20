//
//  UIScrollView+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 20/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)+1
    }
    
    func changeToPage(page: Int) {
        self.setContentOffset(CGPointMake(CGFloat(page) * self.frame.width, 0), animated: true)
    }
}