//
//  CarPoolInvitationViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 30/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIKit

let kConstraintBtnSendHeight : CGFloat = 33.0
let kConstraintImageAlphaFooterHeight : CGFloat = 180.0 //UIApplication.sharedApplication().keyWindow!.bounds.size.height * 0.33

class CarPoolInviteViewController: ViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgAlphaFooter: UIImageView!
    
    @IBOutlet weak var constraintAlphaFooterImgBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintBtnSendHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintBtnSendBottom: NSLayoutConstraint!
    
    var users: [User] = [User]()
    var selectedUsers : [User] = [User]()
    
    let cellReuseIdentifier = "CarPoolInviteCell"
    var poolType: PoolType?
    
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

        self.getUsers { (users) in
            self.users = users!
            self.tableView.dataSource = self
        }
        
        sendButtonView.roundVeryLittleForHeight(kConstraintBtnSendHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarColor(UIColor(rgba: poolType!.color!))
        
        self.setPoolTitle(.Car)
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
    
    // MARK:- Private methods
    
    private func getUsers(completion: (users: [User]?) -> Void) {
        
        var users: [User] = [User]()
        
        for var i in 1 ... 20 {
            let user: User = User()
            user.userId = "\(i)"
            user.name = "Test"
            user.lastName = "User"
            user.profilePicture = "http://www.farandula.ws/wp-content/uploads/2012/02/house-md_0001.jpg"
            
            users.append(user)
        }
        
        completion(users: users)
    }
    
    private func hideAlphaFooter() {
        
        self.constraintAlphaFooterImgBottom.constant = -kConstraintImageAlphaFooterHeight
        self.constraintBtnSendBottom.constant = -kConstraintBtnSendHeight
        
        UIView.animateWithDuration(0.4) { 
            self.view.layoutIfNeeded()
        }
    }
    
    private func showAlphaFooter() {
    
        self.constraintAlphaFooterImgBottom.constant = CGFloat(0)
        self.constraintBtnSendBottom.constant = kConstraintBtnSendHeight
        
        UIView.animateWithDuration(0.4) {
            self.view.layoutIfNeeded()
        }
    }
}

extension CarPoolInviteViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        count = users.count
        
        return count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CarPoolInviteCell
        
        
        cell.configure(self.users[indexPath.row])
        
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor.whiteColor()
            
        case 1:
            cell.backgroundColor = CustomColors.creamyWhiteColor()
            
        default:
            break
        }
        
        if selectedIndexPaths.containsObject(indexPath) {
            cell.selectCell()
        }
        else {
            cell.deselectCell()
        }
        
        return cell
    }
}

extension CarPoolInviteViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.085
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CarPoolInviteCell
        let userToAppend = self.users[indexPath.row]
        self.selectedUsers.append(userToAppend)
        
        selectedIndexPaths.addObject(indexPath)
        
        cell.selectCell()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CarPoolInviteCell
        let userToRemove = self.users[indexPath.row]

        var indexOfUserToRemove = 0
        for user in self.selectedUsers {
            if user.userId == userToRemove.userId {
                break
            } else {
                indexOfUserToRemove = indexOfUserToRemove+1
            }
        }
        
        self.selectedUsers.removeAtIndex(indexOfUserToRemove)
 
        if selectedIndexPaths.containsObject(indexPath) {
            selectedIndexPaths.removeObject(indexPath)
        }
        
        cell.deselectCell()
    }
}

extension CarPoolInviteViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.memory.y < scrollView.contentOffset.y {
            // UP
            showAlphaFooter()
            
        } else {
            // DOWN
            hideAlphaFooter()
        }
    }
}
