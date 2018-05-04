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
    
    var cameFromWellDoneViewController = false
    var poolId = ""
    
    // MARK: - Super
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBorderToView(view: subtitleLabel, color: CustomColors.NavbarTintColor().cgColor)
        initLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !cameFromWellDoneViewController {
            poolId = leaderboardsResponse.poolId!
        }
        
        self.showProgressHud()
        DataProvider.sharedInstance.getLeaderboardsForPool(poolId: poolId) { (leaderboard, error) in
            self.dismissProgressHud()
            
            if let err = error {
                self.showAlert(text: "Error - Leaderboards - \(err)")
                return
            }
            
            if let leaderboardsResponse = leaderboard {
                self.leaderboardsResponse = leaderboardsResponse
                
                if let leaderboards = leaderboardsResponse.leaderboard {
                    self.leaderboards = leaderboards
                    
                    self.configureView()
                    
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
        
        if !cameFromWellDoneViewController {
            configureView()
        }
    }
    
    func configureNavigationBar() {
        setNavigationBarVisible(visible: true)
        self.title = "menu_leaderboards".localize()
        clearNavigationBarcolor()
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "LeaderboardsListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "LeaderboardsListTableViewCell")
        
        self.tableView.separatorStyle = .none
    }
    
    func configureView() {
        self.tableHeaderView.configureForLeaderboards()
        
        self.poolNameLabel.text = self.leaderboardsResponse?.name
        self.poolTypeLabel.text = self.leaderboardsResponse?.poolTypeName
        
        if let dateString = leaderboardsResponse?.endDateTime {
            let dateStringISO = dateString.substringToIndex(index: dateString.characters.count-9)
            
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
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LeaderboardsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return leaderboards.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardsListTableViewCell") as! LeaderboardsListTableViewCell
        cell.configureCellWithLeaderboard(leaderboard: leaderboards[indexPath.row])
        return cell
    }
    
}
