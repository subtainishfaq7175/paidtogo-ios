//
//  ActivityListingViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 12/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class ActivityListingViewController: ViewController {
    
    var activities:[ActivityNotification] = [ActivityNotification]()
    var lastSevenDates:[String] {
        get {
            var array:[String] = [String]()
            
            let count = activities.count
            
            var date = Date()
            for _ in 0...count {
                array.append(date.formatedStingEEEE_MMM_dd())
                date = date.yesterday
            }
            
            return array
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuretTableView()
        getActivities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    func configuretTableView() {
        self.tableView.tableFooterView = UIView()
    }
    
    func getActivities() {
        self.showProgressHud()
        
        guard let userID = User.currentUser?.userId else {
            return
        }
        
        DataProvider.sharedInstance.userActivities(userID, completion:{ (data, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                
                return
            }
            
            if let data = data {
                self.activities = [ActivityNotification]()
                for notification in data {
                    self.activities.append(notification)
                }
                
                self.tableView.reloadData()
            }
            
        })
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ActivityListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let itemCell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier) as! ActivityTableViewCell
        
        itemCell.dateLabel.text = lastSevenDates[indexPath.row]
        
        let activity = activities[indexPath.row]
    
        itemCell.earningsLabel.text = String(format: "$ %.2f", activity.earnedMoney)
        itemCell.pointsLabel.text = "\(activity.earnedPoints) points"
        itemCell.totalCO2OffsetLabel.text = "\(activity.savedCo2) lbs Co2 Offset"
        itemCell.totalGasSavedLabel.text = "\(activity.savedTraffic) Gal. Gas Saved"
        itemCell.totalCaloriesBurnedLabel.text = "\(activity.savedCalories) Calories Burned"
        itemCell.milesLabel.text = "\(activity.bikeMiles) mi"
        itemCell.stepsLabel.text = "\(activity.walkMiles) mi"
        itemCell.workotMinLabel.text = "\(activity.gymCheckIns)"
        
        itemCell.selectionStyle = .none
        
        return itemCell
    }
    
}
