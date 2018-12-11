//
//  PaidtogoProViewController.swift
//  Paidtogo
//
//  Created by Razi Tiwana on 04/12/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class PaidtogoProViewController: MenuContentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    
    // MARK: Private Methods
    
    func configureViews() {
        self.title = "menu_upgradetopro".localize()
        customizeNavigationBarWithMenu()
        
        for subView in self.view.subviews {
            if subView.tag == 10 {
                subView.round()
            }
        }
    
    }
    
}
