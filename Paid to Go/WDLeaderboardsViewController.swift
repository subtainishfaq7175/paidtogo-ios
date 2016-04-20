//
//  WDLeaderboardsViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 15/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class WDLeaderboardsViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    // MARK: - Variables and Constants
    
    var type: PoolType?
    
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

        setPoolColor(backgroundColorView, type: type!)
        clearNavigationBarcolor()
        
    }
    
    // MARK: - Actions
    
}