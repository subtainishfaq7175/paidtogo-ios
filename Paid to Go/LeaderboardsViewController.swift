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
    
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var poolTypeLabel: UILabel!
    
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
        self.poolNameLabel.text = self.leaderboardsResponse?.name
        
//        self.endDateLabel.text = self.leaderboardsResponse.date
        /*/
        guard let dateString = leaderboardsResponse.date else {
            continue
        }
        
        let dateStringISO = dateString.substringToIndex(dateString.characters.count-9)
        
        guard let date = dateStringISO.toDate(DateFormat.Custom("yyyy-MM-dd")) else {
            continue
        }
         */
    }
    
    // MARK: - Actions
    
    func dismiss(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}