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
        //        TODO: - commented by VB

//        self.tableViewHeader.configureForActivities()
//        self.configureTableView()
//        self.getNotifications()
        
        self.title = "menu_activity".localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        TODO: - commented by VBS
//        initLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        initViews()
    }
    
    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == kActivityDetailSegueIdentifier {
            
            if let vc = segue.destination as? ActivityDetailViewController {
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
        
        self.notificationsTableView.separatorStyle = .none
    }
    
    func initLayout() {
        setNavigationBarVisible(visible: true)
//        self.title = "menu_activity".localize()
//        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    func refreshData (sender:AnyObject?) {
        self.getNotifications()
    }
    
    func sortActivitiesByDate() {
        
        notifications.sort { (activityOne, activityTwo) -> Bool in
            
            let dateOne = NSDate.getDateWithFormatddMMyyyy(dateString: activityOne.startDateTime!)
            let dateTwo = NSDate.getDateWithFormatddMMyyyy(dateString: activityTwo.startDateTime!)
            
            return dateOne.compare(dateTwo as Date) == .orderedDescending
        }
    }
    
    func filterActivitiesWithoutDate() {
        
        let filteredActivities = notifications.filter { (activity) -> Bool in
            
            return activity.startDateTime != "0000-00-00 00:00:00"
            
        }
        
        notifications = filteredActivities
    }
    
    private func getNotifications () {
        
        self.showProgressHud(title: "Loading recent activity")
        
        DataProvider.sharedInstance.getActivities { (activityNotifications, error) in
            
            if let error = error {
                self.dismissProgressHud()
                
                // No recent activity
                self.notificationsTableView.isHidden = true
                self.lblEmptyTableView.isHidden = false
                
                return
            }
            
            if let activityNotifications = activityNotifications {
                self.dismissProgressHud()
                
                self.notifications = activityNotifications
                
                if self.notifications.count == 0 {
                    // No recent activity
                    self.notificationsTableView.isHidden = true
                    self.lblEmptyTableView.isHidden = false
                } else {
                    // Recent activity
                    self.notificationsTableView.isHidden = false
                    self.lblEmptyTableView.isHidden = true
                    self.filterActivitiesWithoutDate()
                    self.sortActivitiesByDate()
                    self.notificationsTableView.reloadData()
                }
            }
        }
    }
}

extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellReuseIdentifier) as! ActivityDefaultCell
        
        cell.configure(notification: self.notifications[indexPath.row])
        
        return cell
    }
}

extension ActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.activity = notifications[indexPath.row]
        let activityId = self.activity!.internalIdentifier
        
        self.showProgressHud()
        DataProvider.sharedInstance.getActivityRoute(activityId: activityId!) { (activityRoute, error) in
            self.dismissProgressHud()
            if error == nil {
                self.performSegue(withIdentifier: self.kActivityDetailSegueIdentifier, sender: activityRoute)
            } else {
                self.performSegue(withIdentifier: self.kActivityDetailSegueIdentifier, sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
