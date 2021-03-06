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
    
    @IBOutlet weak var upgradeToProViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    weak var menuController: MainViewController?
    
    typealias MenuItem = (title: String, storyboard: String, identifier: String)
    typealias JSONObject = [String: AnyObject]
    typealias JSONArray = [JSONObject]
    
    private let plistName = "MenuItems"
    
    var items = [MenuItem]()
    
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = loadItemsFromPList(plist: plistName)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
        
        let currentUser = User.currentUser!
        
        nameLabel.text = currentUser.fullName()
       
        if let currentProfilePicture = currentUser.profilePicture, currentUser.profilePicture != "" {
            
            profileImageView.yy_setImage(with: URL(string: currentProfilePicture), placeholder: UIImage(named: "ic_profile_placeholder"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
                
                guard let img = image else {
                    self.profileImageView.image = UIImage(named: "ic_profile_placeholder")
                    return
                }
                
                self.profileImageView.image = img
            })
        } else {
            self.profileImageView.image = UIImage(named: "ic_profile_placeholder")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileUpdated), name: NSNotification.Name(rawValue: NotificationsHelper.UserProfileUpdated.rawValue), object: nil)
    }
    
    @objc private func userProfileUpdated() {
        
        let currentUser = User.currentUser!
        
        nameLabel.text = currentUser.fullName()
        
        if let currentProfilePicture = currentUser.profilePicture, currentUser.profilePicture != "" {
            
            profileImageView.yy_setImage(with: URL(string: currentProfilePicture) , placeholder: UIImage(named: "ic_profile_placeholder"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
                
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
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
//        profileImageView.roundWholeView()
//        nameView.round()
//        proUserLabel.round()
        configureViewForProUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.roundWholeView()
        nameView.round()
        proUserLabel.round()
    }
    
    func configureViewForProUser() {
        
        let user = User.currentUser!
        
        if user.isPro() {
            // Pro User
            proUserLabel.isHidden = false
            goProButtonView.isHidden = true
            upgradeToProViewHeightConstraint.constant = 0.0
        } else {
            proUserLabel.isHidden = true
            goProButtonView.isHidden = false
            upgradeToProViewHeightConstraint.constant = 64.0
        }
        
        self.view.layoutIfNeeded()
        
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
        
        guard let pathToPList = Bundle.main.path(forResource: plist, ofType: "plist") else {
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
            
            menuItems.append((
                title: title.localize(),
                storyboard: storyboard,
                identifier: identifier
            ))
        }
        
        if let firstItem = menuItems.first {
            self.delegate?.setMenuContentViewController(controller: UIStoryboard(name: firstItem.storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: firstItem.identifier))
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goProAction(sender: AnyObject) {
        if let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ProViewController") {
            
            self.present(proVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    // These are the sections in the tableview
    
    // header section is the section in which the profile photo is displayed, with his/her name
    private var headerSection: Int { return 0 }
    
    // items section is the menu items themselves.
    private var itemsSection: Int { return 1}
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return [headerSection,itemsSection].count
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.section == headerSection {
        //            return tableView.dequeueReusableCellWithIdentifier(MenuHeaderCell.identifier) as! MenuHeaderCell
        //        } else {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier) as! MenuItemCell
        
        //        let itemCell = MenuItemCell.deque(from: tableView)
        
        let menuItem = items[indexPath.row]
        
        itemCell.configure(title: menuItem.title)
        return itemCell
    }
    
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == itemsSection {
            // Only handles action for items section. Not for header.
            let selectedItem = items[indexPath.row]
            let controller = UIStoryboard(name: selectedItem.storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: selectedItem.identifier)
            
            self.delegate?.setMenuContentViewController(controller: controller)
        }
    }
 
    
    /*
    func goPro(alert: UIAlertAction!) {
        print("Go Pro")
        
        self.showProgressHud()
        ProUser.store.requestProducts { (success, products) in
            if success {
                print("Product: \(products)")
                
                let userToSend = User()
                userToSend.accessToken = User.currentUser?.accessToken
                userToSend.type = UserType.Pro.rawValue
                
                DataProvider.sharedInstance.postUpdateProfile(userToSend) { (user, error) in
                    self.dismissProgressHud()
                    
                    if let user = user { //success
                        
                        User.currentUser = user
                        self.configureViewForProUser()
                        self.showAlert("Congratulations!! You became a Pro User")
                        
                        
                    } else if let error = error {
                        
                        self.showAlert(error)
                    }
                }
                
            } else {
                print("Error - IAP Failed to get autorenewable subscription")
            }
        }
    }
     */
}
