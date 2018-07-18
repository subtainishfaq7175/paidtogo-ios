//
//  SettingsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

enum SectionTag :Int  {
    case location
    case appNotification
    case emailNotification
    
    static var count :Int {return SectionTag.emailNotification.hashValue + 1}
    
}

enum LocationTag :Int  {
    case geoLocation
    case autoTracking
     static var count :Int {return LocationTag.autoTracking.hashValue + 1}
}

enum AppNotificationTag :Int  {
    case avaliableCouponNearby
    case checkIns
    case newCouponEarned
    case avaliableOffersNearMe
    case weeklyOffers
    case monthlyOffers
    static var count :Int {return AppNotificationTag.monthlyOffers.hashValue + 1}
}

enum EmailNotificationTag :Int {
    case newOffersNearMe
    case newCouponEarned
    static var count :Int {return EmailNotificationTag.newCouponEarned.hashValue + 1}
}

class SettingsViewController: MenuContentViewController {
    // MARK: - Outlets
    
     @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables and Constants
    
    
    // MARK: - View life cycle
    
    typealias MenuItem = (title: String, storyboard: String, identifier: String)
    typealias JSONObject = [String: AnyObject]
    typealias JSONArray = [JSONObject]
    
    let sectionTitles = ["Location", "App Notification", "Email Notificaion"]
   
    let locationRows = ["Geolocation", "Auto Tracking"]
    
    let appNotificationRows = ["Available Coupon Nearby", "Check Ins", "New Coupon Earned","Available Offers Near Me", "Weekly Offers", "Monthly Offers"]
    
    let emailNotificationRows = ["New offers Near Me ", "New Coupons Earned"]
    
    
    var items = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
        setuptableView()
        setupViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Functions
    
    private func setupViewController() {
        title = "Settings"
    }
    
    func setuptableView()  {
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.sectionHeaderHeight = 44
        self.tableView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    }
    
    
    // MARK: - Actions

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // These are the sections in the tableview
    
    // header section is the section in which the profile photo is displayed, with his/her name
    private var headerSection: Int { return 0 }
    
    // items section is the menu items themselves.
    private var itemsSection: Int { return 1}
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTag.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionTag = SectionTag(rawValue: section) {
            
            switch sectionTag {
                
            case .location:
                // the header section has only one cell, the header itself
                return LocationTag.count
                
            case .appNotification:
                return AppNotificationTag.count
                
            case .emailNotification:
                return EmailNotificationTag.count
                
                //        case SectionTag.others:
                //            return self.items.count
                
            default:
                log.warning("Unhandled section")
                return 0
            }
        }
         return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.section == headerSection {
        //            return tableView.dequeueReusableCellWithIdentifier(MenuHeaderCell.identifier) as! MenuHeaderCell
        //        } else {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: SettingSwitchTableViewCell.identifier) as! SettingSwitchTableViewCell
        
        itemCell.delegate = self
        itemCell.section = indexPath.section
        itemCell.row = indexPath.row
        
        itemCell.selectionStyle = .none
        itemCell.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        
        var title:String? = nil
        
        if let sectionTag = SectionTag(rawValue: indexPath.section) {
            
            switch sectionTag {
                
            case .location:
                title = locationRows[indexPath.row]
                break;
            case .appNotification:
                title = appNotificationRows[indexPath.row]
                 break;
            case .emailNotification:
                title = emailNotificationRows[indexPath.row]
                break;
            }
        }
        
        if let title1 = title {
           itemCell.configure(title: title1)
            
        }
        
        return itemCell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 44))
        
        let textLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.size.width, height: 44))
        
        textLabel.text = sectionTitles[section]
        
        headerView.addSubview(textLabel)
        
        headerView.backgroundColor =  #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        return headerView
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//
//        case headerSection:
//            return 45.0
//
//        case itemsSection:
//            return 45.0
//
//        default:
//            log.error("Unhandled section")
//            return 0.0
//
//        }
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        if indexPath.section == itemsSection {
//            // Only handles action for items section. Not for header.
//            let selectedItem = items[indexPath.row]
//            let controller = UIStoryboard(name: selectedItem.storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: selectedItem.identifier)
//
//            self.delegate?.setMenuContentViewController(controller: controller)
//        }
//    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: SettingSwitchTableViewCellDelegate {
    
    func didChangeSwitch(state: Bool, on section:Int, and row:Int) {
        
        if let sectionTag = SectionTag(rawValue: section) {
            
            switch sectionTag {
                
            case .location:
                if let rowTag = LocationTag(rawValue: row) {
                    switch rowTag {
                        
                    case .geoLocation:
                        break;
                        
                    case .autoTracking:
                        Settings.shared.isAutoTrackingOn = state
                        break;
                    }
                }
                break;
                
            case .appNotification:
                if let rowTag = AppNotificationTag(rawValue: row) {
                    switch rowTag {
                        
                    case .avaliableCouponNearby:
                        break;
                        
                    case .avaliableOffersNearMe:
                        break;
                        
                    case .checkIns:
                        break;
                        
                    case .monthlyOffers:
                        break;
                        
                    case .newCouponEarned:
                        break;
                        
                    case .weeklyOffers:
                        break;
                    }
                }
                break;
                
            case .emailNotification:
                if let rowTag = EmailNotificationTag(rawValue: row) {
                    switch rowTag {
                        
                    case .newCouponEarned:
                        break;
                        
                    case .newOffersNearMe:
                        break;
                    }
                }
                break;
                
            }
        }
    }
    
}

