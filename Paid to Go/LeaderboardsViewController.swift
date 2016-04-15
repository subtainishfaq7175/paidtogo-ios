//
//  ActivityViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class LeaderboardsViewController: MenuContentViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    
    // MARK: - Variables and Constants
    
    
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
      
        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    // MARK: - Functions
    
    
    func initViews(){
    }
    
    func initLayout() {
        setNavigationBarVisible(true)
        self.title = "menu_leaderboards".localize()
        clearNavigationBarcolor()
        customizeNavigationBarWithMenu()
    }
    
    // MARK: - Actions
    
    func dismiss(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}