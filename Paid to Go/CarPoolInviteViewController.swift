//
//  CarPoolInvitationViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 30/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIKit

let kConstraintBtnSendHeight : CGFloat = 50.0
let kConstraintImageAlphaFooterHeight : CGFloat = 180.0 //UIApplication.sharedApplication().keyWindow!.bounds.size.height * 0.33

class CarPoolInviteViewController: ViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgAlphaFooter: UIImageView!
    
    @IBOutlet weak var constraintAlphaFooterImgBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintBtnSendHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintBtnSendBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnAlphaFooter: UIButton!
    
    @IBOutlet weak var lblEmptyResults: UILabel!
    
    let cellReuseIdentifier = "CarPoolInviteCell"
    let kDefaultSearchBarText = "a"
    
    var users: [User] = [User]()
    var selectedUsers : [User] = [User]()
    var type : PoolTypeEnum?
    var poolType: PoolType?
    var pool: Pool?
    var footerHidden = false
    
    // Handle multiple selection properly http://stackoverflow.com/questions/28360919/my-table-view-reuse-the-selected-cells-when-scroll-in-swift
    var selectedIndexPaths = NSMutableSet()
    
    // MARK:- View Lifecycle
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //sendButtonView.round()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        sendButtonView.roundVeryLittleForHeight(height: kConstraintBtnSendHeight)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CarPoolInviteViewController.handleTap(recognizer:)))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setPoolTitle(type: .Car)
        self.navigationController?.navigationBar.barTintColor = CustomColors.carColor()
        self.navigationController?.navigationBar.isTranslucent = false
//        self.setNavigationBarColor(UIColor(rgba: poolType!.color!))
        
        self.searchUsersWithText(text: kDefaultSearchBarText)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - Private Methods -
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        if searchBar.isFirstResponder {
//            self.view.endEditing(true)
            self.searchBar.resignFirstResponder()
//            self.searchBar.endEditing(true)
        }
    }
    
    // MARK:- IBActions
    
    @IBAction func sendButtonAction(sender: AnyObject) {
        if !footerHidden {
            hideAlphaFooter()
            footerHidden=true
        } else {
            showAlphaFooter()
            footerHidden=false
        }
    }
    
    @IBAction func btnAlphaFooterPressed(sender: AnyObject) {
    
        self.showAlphaFooter()
    }
    
    @IBAction func btnAlphaFooterDown(sender: AnyObject) {
    
        self.hideAlphaFooter()
    }
    
    @IBAction func btnSendInvitationEmailPressed(sender: AnyObject) {
    
        self.sendEmailToUsers()
    }
    
    // MARK:- Private methods
    
     func hideAlphaFooter() {
        
        self.constraintAlphaFooterImgBottom.constant = -kConstraintImageAlphaFooterHeight
        self.constraintBtnSendBottom.constant = -kConstraintBtnSendHeight
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.btnAlphaFooter.alpha = CGFloat(1)
        }
    }
    
     func showAlphaFooter() {
    
        self.constraintAlphaFooterImgBottom.constant = CGFloat(0)
        self.constraintBtnSendBottom.constant = kConstraintBtnSendHeight
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.btnAlphaFooter.alpha = CGFloat(0)
        }
    }
    
    // MARK:- API Calls

    func searchUsersWithText(text: String) {

        self.showProgressHud(title: "Searching...")
        
        DataProvider.sharedInstance.searchUsersByName(username: text) { (users, error) in
            
            if let error = error {
                self.dismissProgressHud()
                
                self.users.removeAll()
                self.tableView.reloadData()
                
                if self.users.count == 0 {
                    self.lblEmptyResults.isHidden = false
                } else {
                    self.lblEmptyResults.isHidden = true
                }
                
                return
            }
            
            if let users = users {
                self.dismissProgressHud()
                
                self.users = users
                self.tableView.reloadData()
                
                if self.users.count == 0 {
                    self.lblEmptyResults.isHidden = false
                } else {
                    self.lblEmptyResults.isHidden = true
                }
            }
        }
    }
    
    private func sendEmailToUsers() {
        
        if selectedUsers.count == 0 {
            self.showAlert(text: "Please select one or more users to send the invitations to!")

            return
        }
        
        self.showProgressHud(title: "Sending email...")
        
        var selectedUserIDs = Array <String> ()
        for user in selectedUsers {
            guard let userID = user.userId else { return }
            selectedUserIDs.append(userID)
        }
        
        DataProvider.sharedInstance.sendEmailToUsers(users: selectedUserIDs, poolId: (self.pool?.internalIdentifier)!) { (result, error) in
            
            self.dismissProgressHud()
            
            guard let err = error else {
                
                DataProvider.sharedInstance.getPoolType(poolTypeEnum: .Car) { (poolType, error) in
                    
                    if let error = error {
                        self.showAlert(text: error)
                        return
                    }
                    
                    if let poolType = poolType {
                        
                        if let poolViewController = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "PoolViewController") as? PoolViewController {
                            poolViewController.type = self.type
                            poolViewController.poolType = poolType
                            poolViewController.pool = self.pool
                            
                            self.navigationController?.pushViewController(poolViewController, animated: true)
                        }
                    }
                }
                
                return
            }
            
            self.showAlert(text: "Unable to send invitations")
        }
    }
}

extension CarPoolInviteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        count = users.count
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CarPoolInviteCell
        
        
        cell.configure(user: self.users[indexPath.row])
        
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor.white
            
        case 1:
            cell.backgroundColor = CustomColors.creamyWhiteColor()
            
        default:
            break
        }
        
        if selectedIndexPaths.contains(indexPath) {
            cell.selectCell()
        }
        else {
            cell.deselectCell()
        }
        
        return cell
    }
}

extension CarPoolInviteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.085
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CarPoolInviteCell
        let userToAppend = self.users[indexPath.row]
        self.selectedUsers.append(userToAppend)
        
        selectedIndexPaths.add(indexPath)
        
        cell.selectCell()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath ) as! CarPoolInviteCell
        let userToRemove = self.users[indexPath.row]

        var indexOfUserToRemove = 0
        for user in self.selectedUsers {
            if user.userId == userToRemove.userId {
                break
            } else {
                indexOfUserToRemove = indexOfUserToRemove+1
            }
        }
        
        self.selectedUsers.remove(at: indexOfUserToRemove)
 
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
        }
        
        cell.deselectCell()
    }
}

extension CarPoolInviteViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            // UP
            self.showAlphaFooter()
            
        } else {
            // DOWN
            self.hideAlphaFooter()
        }
    }
}

extension CarPoolInviteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let text = searchBar.text else {
            return
        }
        
        self.searchUsersWithText(text: text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

