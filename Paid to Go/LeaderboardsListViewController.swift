//
//  LeaderboardsListViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 13/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit



final class LeaderboardsListViewController: MenuContentViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEmptyTable: UILabel!
    
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    
    // MARK: - Variables and constants
    
    var leaderboards : [LeaderboardsResponse] = [LeaderboardsResponse]() {
        didSet {
            if leaderboards.count == 0 {
                self.tableView.hidden = true
                self.lblEmptyTable.hidden = false
            } else {
                self.tableView.hidden = false
                self.lblEmptyTable.hidden = true
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        DataProvider.sharedInstance.getLeaderboards { (leaderboards, error) in
            
            guard let leaderboards = leaderboards else {
                return
            }
            
            self.leaderboards = leaderboards
            
            self.tableView.reloadData()
        }
        
        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        initLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        initLayout()
    }
    
    // MARK: - Private Methods
    
    func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: String(LeaderboardsListTableViewCell), bundle: nil), forCellReuseIdentifier: String(LeaderboardsListTableViewCell))
        self.tableView.separatorStyle = .None
    }
    
    func initLayout() {
        setNavigationBarVisible(true)
        self.title = "menu_leaderboards".localize()
        clearNavigationBarcolor()
        customizeNavigationBarWithMenu()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! LeaderboardsViewController
//        let leaderboard = sender as! Leaderboard
        
        vc.leaderboardResponse = sender as LeaderboardsResponse!
    }
    
    // MARK: - Actions
    
    func dismiss(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LeaderboardsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaderboards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(LeaderboardsListTableViewCell)) as! LeaderboardsListTableViewCell
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        cell.configureCellWithLeaderboardsResponse(self.leaderboards[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*
        guard let leaderboards = self.leaderboards[indexPath.row].leaderboard as [Leaderboard]?,
            leaderboard = leaderboards.first as Leaderboard? else {
            
                return
        }
        
        self.performSegueWithIdentifier("leaderboardsSegue", sender: leaderboard)
         */
        
        self.performSegueWithIdentifier("leaderboardsSegue", sender: self.leaderboards[indexPath.row])
    }
}
