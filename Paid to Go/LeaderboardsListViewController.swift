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
    
    @IBOutlet weak var tableHeaderView: TableViewHeader!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEmptyTable: UILabel!
    
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    
    // MARK: - Variables and constants
    
    var leaderboards : [LeaderboardsResponse] = [LeaderboardsResponse]() {
        didSet {
            if leaderboards.count == 0 {
                // No leaderboards to show
                DispatchQueue.main.async {
                    self.tableView.isHidden = true
                    self.lblEmptyTable.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.lblEmptyTable.isHidden = true
                }
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showProgressHud()
        DataProvider.sharedInstance.getLeaderboards { (leaderboards, error) in
            self.dismissProgressHud()
            
            guard let leaderboards = leaderboards else {
                
                self.tableView.isHidden = true
                self.lblEmptyTable.isHidden = false
                
                return
            }
            
            self.leaderboards = leaderboards
            
            self.tableView.reloadData()
        }
        
        setBorderToView(view: subtitleLabel, color: CustomColors.NavbarTintColor().cgColor)
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
        self.tableView.register(UINib(nibName: "LeaderboardsListTableViewCell", bundle: nil), forCellReuseIdentifier:
            "LeaderboardsListTableViewCell")
        self.tableView.separatorStyle = .none
    }
    
    func initLayout() {
        setNavigationBarVisible(visible: true)
        self.title = "menu_leaderboards".localize()
        clearNavigationBarcolor()
        customizeNavigationBarWithMenu()
        self.tableHeaderView.configureForLeaderboardsList()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LeaderboardsViewController
        //        let leaderboard = sender as! Leaderboard
        
        vc.leaderboardsResponse = sender as! LeaderboardsResponse
    }
   
    // MARK: - Actions
    
    func dismiss(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension LeaderboardsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaderboards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardsListTableViewCell") as! LeaderboardsListTableViewCell
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        cell.configureCellWithLeaderboardsResponse(leaderboardsResponse: self.leaderboards[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "leaderboardsSegue", sender: self.leaderboards[indexPath.row])

    }
    
}
