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
    @IBOutlet weak var lblEmptyTableView: UILabel!
    
    // MARK: - Variables and Constants
    
    let simpleCellReuseIdentifier = "activitySimpleCell"
    let defaultCellReuseIdentifier = "activityDefaultCell"
    let actionCellReuseIdentifier = "activityActionCell"
    
    var notifications:[ActivityNotification] = [ActivityNotification]() {
        didSet {
            if notifications.count == 0 {
                print("No recent activity...")
                self.notificationsTableView.hidden = true
                self.lblEmptyTableView.hidden = false
            } else {
                print("Recent activity")
                self.notificationsTableView.hidden = false
                self.lblEmptyTableView.hidden = true
            }
        }
    }
    
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
        
        self.showProgressHud("Loading recent activity")
        
        DataProvider.sharedInstance.getActivities { (activityNotifications, error) in
            
            if let error = error {
                self.dismissProgressHud()
                
//                self.showAlert("No recent activity")
                return
            }
            
            if let activityNotifications = activityNotifications {
                self.dismissProgressHud()

                self.notifications = activityNotifications
                self.notificationsTableView.reloadData()
            }
        }
    }
}
extension ActivityViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCellWithIdentifier(defaultCellReuseIdentifier) as! ActivityDefaultCell
            
            cell.configure(self.notifications[indexPath.row])
            
            return cell
            
        
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