//
//  CarPoolInvitationViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 30/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIKit

class CarPoolInviteViewController: ViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = [User]()
    let cellReuseIdentifier = "CarPoolInviteCell"
    var poolType: PoolType?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sendButtonView.round()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self

        self.getUsers { (users) in
            self.users = users!
            self.tableView.dataSource = self
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarColor(UIColor(rgba: poolType!.color!))
        
        self.setPoolTitle(.Car)
    }
    @IBAction func sendButtonAction(sender: AnyObject) {
        
    }
    
    private func getUsers(completion: (users: [User]?) -> Void) {
        
        var users: [User] = [User]()
        
        for var i in 1 ... 9 {
            let user: User = User()
            user.name = "Test"
            user.lastName = "User"
            user.profilePicture = "http://www.farandula.ws/wp-content/uploads/2012/02/house-md_0001.jpg"
            
            
            users.append(user)
        }
        
        
        completion(users: users)
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
        
        return cell
        
    }
}

extension CarPoolInviteViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.085
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CarPoolInviteCell
        
        cell.selectCell()
        
    }
    
}
