//
//  SettingsViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class ActivityViewController: MenuContentViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    // MARK: - Variables and Constants
    
    let simpleCellReuseIdentifier = "activitySimpleCell"
    let defaultCellReuseIdentifier = "activityDefaultCell"
    let actionCellReuseIdentifier = "activityActionCell"
    
    var notifications:[Notification] = [Notification]()
    
    
    // MARK: - Super
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationsTableView.delegate = self
        self.notificationsTableView.dataSource = self
        
        self.getNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "menu_activity".localize()
        //        self.setNavigationBarTitle("Notifications_title".localize())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        initViews()
    }
    
    // MARK: - Functions
    
    
    
    func refreshData (sender:AnyObject?) {
        
        self.getNotifications()
        
    }
    
    private func getNotifications () {
        
        DataProvider.sharedInstance.getNotifications { (notifications) -> Void in
            
            self.notifications = notifications
            self.notificationsTableView.reloadData()
            //            self.refreshControl.endRefreshing()
        }
    }
}
extension ActivityViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch self.notifications[indexPath.row].type {
        case 0: // SIMPLE CELL
            let cell = tableView.dequeueReusableCellWithIdentifier(simpleCellReuseIdentifier) as! ActivitySimpleCell
            
            cell.configure(self.notifications[indexPath.row])
            
            return cell
            
        case 1: // DEFAULT CELL
            let cell = tableView.dequeueReusableCellWithIdentifier(defaultCellReuseIdentifier) as! ActivityDefaultCell
            
            cell.configure(self.notifications[indexPath.row])
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(simpleCellReuseIdentifier) as! ActivitySimpleCell
            
            cell.configure(self.notifications[indexPath.row])
            
            return cell
        }
        
    }
}
extension ActivityViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(simpleCellReuseIdentifier) as! ActivitySimpleCell
        
        //        self.notifications[indexPath.row].read = true
        
        //        cell.read(self.notifications[indexPath.row].read)
        
        tableView.reloadData()
        
        // TODO Notification navigation
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.085
    }
}