//
//  ActivityViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class LeaderboardsViewController: ViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    // MARK: - Variables and Constants
    var leaderboardsResponse : LeaderboardsResponse?
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        initLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    // MARK: - Functions
    
    func initViews() {
    
    }
    
    func initLayout() {
        
        configureNavigationBar()
        configureView()
    }
    
    func configureNavigationBar() {
        setNavigationBarVisible(true)
        self.title = "menu_leaderboards".localize()
        clearNavigationBarcolor()
    }
    
    func configureView() {
//        self.endDateLabel.text = self.leaderboardsResponse.date
    }
    
    // MARK: - Actions
    
    func dismiss(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}