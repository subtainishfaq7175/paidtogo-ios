//
//  MenuViewController.swift
//  Care4
//
//  Created by Fernando Ortiz on 1/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func setMenuContentViewController(controller: UIViewController)
}

class MenuViewController: ViewController {
    
    // MARK: - IBOutlet -
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var goProButton: UIButton!
    @IBOutlet weak var goProButtonView: UIView!
    
    @IBOutlet weak var proUserLabel: UILabel!
    
    weak var menuController: MainViewController?
    
    // MARK: - Variables
    typealias MenuItem = (title: String, storyboard: String, identifier: String)
    typealias JSONObject = [String: AnyObject]
    typealias JSONArray = [JSONObject]
    private let plistName = "MenuItems"
    
    var items = [MenuItem]()
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - Test
    
    var userIsPro = false
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = loadItemsFromPList(plistName)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
        
        let currentUser = User.currentUser!
        
        nameLabel.text = currentUser.fullName()
       
        if let currentProfilePicture = currentUser.profilePicture where currentUser.profilePicture?.characters.count > 0 {
            
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), placeholder: UIImage(named: "ic_profile_placeholder"), options: .ShowNetworkActivity, completion: { (image, url, type, stage, error) in
                
                guard let img = image else {
                    self.profileImageView.image = UIImage(named: "ic_profile_placeholder")
                    return
                }
                
                self.profileImageView.image = img
            })
        } else {
            self.profileImageView.image = UIImage(named: "ic_profile_placeholder")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userProfileUpdated), name: NotificationsHelper.UserProfileUpdated.rawValue, object: nil)
    }
    
    @objc private func userProfileUpdated() {
        
        let currentUser = User.currentUser!
        
        nameLabel.text = currentUser.fullName()
        
        if let currentProfilePicture = currentUser.profilePicture where currentUser.profilePicture?.characters.count > 0 {
            
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), placeholder: UIImage(named: "ic_profile_placeholder"), options: .ShowNetworkActivity, completion: { (image, url, type, stage, error) in
                
                guard let img = image else {
                    self.profileImageView.image = UIImage(named: "ic_profile_placeholder")
                    return
                }
                
                self.profileImageView.image = img
            })
        } else {
            self.profileImageView.image = UIImage(named: "ic_profile_placeholder")
        }
        
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        profileImageView.roundWholeView()
        nameView.round()
        proUserLabel.round()
        configureViewForProUser()
    }
    
    func configureViewForProUser() {
        
        let user = User.currentUser!
        
        if let userType = user.type {
            
            if userType.characters.count > 0 && userType == "1" {
                // Pro User
                proUserLabel.hidden = false
                goProButtonView.hidden = true
            } else {
                proUserLabel.hidden = true
                goProButtonView.hidden = false
            }
        } else {
            proUserLabel.hidden = true
            goProButtonView.hidden = false
        }
    }
    
    // MARK: - Utils
    
    func setMainViewController(menuViewController: MainViewController){
        self.menuController = menuViewController
    }
    
    /**
    Generates an array of MenuItem from a plist given by param. The plist has to define
    an array of dictionaries. Each dictionary must have:
    
    - title         -> String
    - icon          -> String
    - storyboard    -> String
    - identifier    -> String
    
    
    The title purpose is obvious. It defines the name with which the item
    will be displayed in the menu.
    
    The icon is also obvious. It defines the asset name from xcasset with which the item
    will be represented in the menu.
    
    Storyboard and identifier defines the view controller that will be displayed on cell tap.
    
    - parameter plist: the plist name
    
    - returns: an array of MenuItem (see definition, it's a typealias)
    */
    private func loadItemsFromPList(plist: String) -> [MenuItem] {
        
        var menuItems = [MenuItem]()
        
        guard let pathToPList = NSBundle.mainBundle().pathForResource(plist, ofType: "plist") else {
            log.error("Path to plist is invalid")
            return menuItems
        }
        
        guard let itemsArray = NSArray(contentsOfFile: pathToPList) as? JSONArray else {
            log.error("items dictionary defined in plist is not a json array.")
            return menuItems
        }
        
        for item in itemsArray {
            guard   let title       = item["title"]      as? String,
                let storyboard  = item["storyboard"] as? String,
                let identifier  = item["identifier"] as? String else {
                    
                    
                    log.error("there was a problem while reading MenuItems.plist , please review plist format.")
                    return [MenuItem]()
            }
            
            menuItems.append(
                title: title.localize(),
                storyboard: storyboard,
                identifier: identifier
            )
        }
        
        if let firstItem = menuItems.first {
            self.delegate?.setMenuContentViewController(UIStoryboard(name: firstItem.storyboard, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(firstItem.identifier))
        }
        
        return menuItems
    }
    
    // MARK: - IBActions -
    
    @IBAction func menuAction(sender: AnyObject) {
        self.menuController?.hideMenuViewController()
    }
    
    @IBAction func profileAction(sender: AnyObject) {
        /*
        let selectedItem = items[indexPath.row]
        let controller = UIStoryboard(name: selectedItem.storyboard, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(selectedItem.identifier)
        self.delegate?.setMenuContentViewController(controller)
         */
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goProAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Become a Premium User!", message:
            "Do you want to buy a one year subscription for $29.99?\n\n[premium users duplicate earnings per mile in every pool]", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
        alertController.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default,handler: goPro))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    // These are the sections in the tableview
    
    // header section is the section in which the profile photo is displayed, with his/her name
    private var headerSection: Int { return 0 }
    
    // items section is the menu items themselves.
    private var itemsSection: Int { return 1}
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return [
            headerSection,
            itemsSection
            ].count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case headerSection:
            // the header section has only one cell, the header itself
            return 0
            
        case itemsSection:
            return self.items.count
            
        default:
            log.warning("Unhandled section")
            return 0
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        if indexPath.section == headerSection {
        //            return tableView.dequeueReusableCellWithIdentifier(MenuHeaderCell.identifier) as! MenuHeaderCell
        //        } else {
        let itemCell = tableView.dequeueReusableCellWithIdentifier(MenuItemCell.identifier) as! MenuItemCell
        
//        let itemCell = MenuItemCell.deque(from: tableView)
        
        let menuItem = items[indexPath.row]
        
        itemCell.configure(title: menuItem.title)
        return itemCell
        
        //        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
            
        case headerSection:
            return 45.0
            
        case itemsSection:
            return 45.0
            
        default:
            log.error("Unhandled section")
            return 0.0
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == itemsSection {
            // Only handles action for items section. Not for header.
            let selectedItem = items[indexPath.row]
            let controller = UIStoryboard(name: selectedItem.storyboard, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(selectedItem.identifier)
            
            self.delegate?.setMenuContentViewController(controller)
        }
    }
    
    func goPro(alert: UIAlertAction!) {
        print("Go Pro")
        
        self.showProgressHud()
        ProUser.store.requestProducts { (success, products) in
            self.dismissProgressHud()
            if success {
                print("Product: \(products)")
                self.userIsPro = true
                
                let user = User.currentUser
                user?.type = "1"
                User.currentUser = user
                
                self.configureViewForProUser()
                
                self.showAlert("Congratulations!! You became a Pro User")
                
            } else {
                print("Error")
            }
        }
        
    }
}