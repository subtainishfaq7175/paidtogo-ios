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
    
    @IBOutlet weak var tableViewHeader: TableViewHeader!
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var lblEmptyTableView: UILabel!
    
    // MARK: - Variables and Constants
    
    internal let kActivityDetailSegueIdentifier = "activityDetailSegue"
    
    let simpleCellReuseIdentifier = "activitySimpleCell"
    let defaultCellReuseIdentifier = "activityDefaultCell"
    let actionCellReuseIdentifier = "activityActionCell"
    
    var activity : ActivityNotification?
    
    var notifications:[ActivityNotification] = [ActivityNotification]()
//    {
//        didSet {
//            if notifications.count == 0 {
//                // No recent activity
//                self.notificationsTableView.hidden = true
//                self.lblEmptyTableView.hidden = false
//            } else {
//                // Recent activity
//                self.notificationsTableView.hidden = false
//                self.lblEmptyTableView.hidden = true
//            }
//        }
//    }
    
    // MARK: - Super
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewHeader.configureForActivities()
        self.configureTableView()
        self.getNotifications()
        
        self.title = "menu_activity".localize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        initViews()
    }
    
    // MARK: - Navigation -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kActivityDetailSegueIdentifier {
            
            if let vc = segue.destinationViewController as? ActivityDetailViewController {
                vc.activity = self.activity
                
                if let activityRoute = sender as? [ActivitySubroute] {
                    vc.activityRoute = activityRoute
                }
            }
        }
    }
    
    // MARK: - Functions -
    
    func configureTableView() {
        
        self.notificationsTableView.delegate = self
        self.notificationsTableView.dataSource = self
        self.notificationsTableView.rowHeight = UITableViewAutomaticDimension
        
        self.notificationsTableView.separatorStyle = .None
    }
    
    func initLayout() {
        setNavigationBarVisible(true)
//        self.title = "menu_activity".localize()
//        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    func refreshData (sender:AnyObject?) {
        self.getNotifications()
    }
    
    func sortActivitiesByDate() {
        
        notifications.sortInPlace { (activityOne, activityTwo) -> Bool in
            
            let dateOne = NSDate.getDateWithFormatddMMyyyy(activityOne.startDateTime!)
            let dateTwo = NSDate.getDateWithFormatddMMyyyy(activityTwo.startDateTime!)
            
            return dateOne.compare(dateTwo) == .OrderedDescending
        }
    }
    
    func filterActivitiesWithoutDate() {
        
        let filteredActivities = notifications.filter { (activity) -> Bool in
            
            return activity.startDateTime != "0000-00-00 00:00:00"
            
        }
        
        notifications = filteredActivities
    }
    
    private func getNotifications () {
        
        self.showProgressHud("Loading recent activity")
        
        DataProvider.sharedInstance.getActivities { (activityNotifications, error) in
            
            if let error = error {
                self.dismissProgressHud()
                
                // No recent activity
                self.notificationsTableView.hidden = true
                self.lblEmptyTableView.hidden = false
                
                return
            }
            
            if let activityNotifications = activityNotifications {
                self.dismissProgressHud()
                
                self.notifications = activityNotifications
                
                if self.notifications.count == 0 {
                    // No recent activity
                    self.notificationsTableView.hidden = true
                    self.lblEmptyTableView.hidden = false
                } else {
                    // Recent activity
                    self.notificationsTableView.hidden = false
                    self.lblEmptyTableView.hidden = true
                    self.filterActivitiesWithoutDate()
                    self.sortActivitiesByDate()
                    self.notificationsTableView.reloadData()
                }
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
        
        self.activity = notifications[indexPath.row]
        let activityId = self.activity!.internalIdentifier
        
        self.showProgressHud()
        DataProvider.sharedInstance.getActivityRoute(activityId!) { (activityRoute, error) in
            self.dismissProgressHud()
            if error == nil {
                self.performSegueWithIdentifier(self.kActivityDetailSegueIdentifier, sender: activityRoute)
            } else {
                self.performSegueWithIdentifier(self.kActivityDetailSegueIdentifier, sender: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
}
