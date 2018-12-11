//
//  TermsAndConditionsUpgradeViewController.swift
//  Paidtogo
//
//  Created by Razi Tiwana on 04/12/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class TermsAndConditionsUpgradeViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    // MARK: Private Methods
    
    func configureViews() {
        self.title = "terms_label".localize()
        
        for subView in self.view.allSubViewsOf(type: UIView.self) {
            if subView.tag == 10 {
                subView.round()
            }
        }
    }
        
}
