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
    
    var poolType: PoolType?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sendButtonView.round()

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarColor(UIColor(rgba: poolType!.color!))

        self.setPoolTitle(.Car)
    }
    @IBAction func sendButtonAction(sender: AnyObject) {
        
    }
    
}
