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
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
        self.title = "Settings"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initViews()
    }
    
    // MARK: - Functions
    
    func initViews() {
        okButtonViewContainer.round()
    }
    
    
    // MARK: - Actions
    

}
