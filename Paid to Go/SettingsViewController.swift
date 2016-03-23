//
//  SettingsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class SettingsViewController: MenuContentViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var okButtonViewContainer: UIView!
    
    // MARK: - Variables and Constants
    
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        self.title = "Settings"
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    // MARK: - Functions
    
    func initViews(){
        okButtonViewContainer.round()
    }
    
    // MARK: - Actions
    

}