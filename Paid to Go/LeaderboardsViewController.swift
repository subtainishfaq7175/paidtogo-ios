//
//  ActivityViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import SwiftDate

class LeaderboardsViewController: ViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var tableHeaderView: TableViewHeader!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var poolTypeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var suffixLabel: UILabel!
        
    // MARK: - Variables and Constants
    var leaderboards = [Leaderboard]()
    var leaderboardsResponse : LeaderboardsResponse!
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        initLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showProgressHud()
        DataProvider.sharedInstance.getLeaderboardsForPool(leaderboardsResponse.poolId!) { (leaderboard, error) in
            self.dismissProgressHud()
            
            if let err = error {
                self.showAlert("Error - Leaderboards - \(err)")
                return
            }
            
            if let leaderboardsResponse = leaderboard {
                if let leaderboards = leaderboardsResponse.leaderboard {
                    
                    self.leaderboards = leaderboards
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Functions
    
    func initLayout() {
        
        configureNavigationBar()
        configureTableView()
        configureView()
    }
    
    func configureNavigationBar() {
        setNavigationBarVisible(true)
        self.title = "menu_leaderboards".localize()
        clearNavigationBarcolor()
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: String(LeaderboardsListTableViewCell), bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: String(LeaderboardsListTableViewCell))
        
        self.tableView.separatorStyle = .None
    }
    
    func configureView() {
        self.tableHeaderView.configureForLeaderboards()
        
        self.poolNameLabel.text = self.leaderboardsResponse?.name
        self.poolTypeLabel.text = self.leaderboardsResponse?.poolTypeName
        
        if let dateString = leaderboardsResponse?.endDateTime {
            let dateStringISO = dateString.substringToIndex(dateString.characters.count-9)
            
            self.endDateLabel.text = dateStringISO
        }
        
        if let leaderboards = self.leaderboardsResponse?.leaderboard {
            if let userLeaderboard = leaderboards.first {
                if let place = userLeaderboard.place {
                    self.positionLabel.text = String(place)
                    self.suffixLabel.text = place.ordinal
                }
            }
        }
    }
    
    // MARK: - Actions
    
    func dismiss(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension LeaderboardsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(LeaderboardsListTableViewCell)) as! LeaderboardsListTableViewCell
        cell.configureCellWithLeaderboard(leaderboards[indexPath.row])
        return cell
    }
}