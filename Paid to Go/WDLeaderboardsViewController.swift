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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var leaderboard: LeaderboardsResponse?
    var poolId: String?
    let cellReuseIdentifier = "leaderboardCell"
    
    // MARK: - Super
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.getData()
    }
    
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
    
    private func getData() {
        self.showProgressHud()
        
        DataProvider.sharedInstance.getLeaderboards(self.poolId!) { (leaderboard, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                return
            }
            
            if let leaderboard = leaderboard {
                
                self.tableView.dataSource = self

                self.leaderboard  = leaderboard
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    
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


extension WDLeaderboardsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.leaderboard?.leaderboard!.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! LeaderboardCell
        
        
        cell.configure((self.leaderboard?.leaderboard![indexPath.row])!)
        
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor.whiteColor()
            
        case 1:
            cell.backgroundColor = CustomColors.creamyWhiteColor()
            
            
        default:
            break
        }
        
        return cell
        
    }
}

extension WDLeaderboardsViewController: UITableViewDelegate {
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! PoolCell
    //
    //
    //        tableView.reloadData()
    //
    //    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.085
    }
}


