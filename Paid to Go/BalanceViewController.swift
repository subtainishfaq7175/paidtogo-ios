//
//  SettingsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class BalanceViewController: MenuContentViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var redemedLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var accountMoneyLabel: UILabel!
    
    // MARK: - Variables and Constants
    
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        self.title = "menu_balance".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    // MARK: - Functions
    
    func initViews(){
    }
    
    private func getData() {
        self.showProgressHud()
        
        let user: User!
        user = User()
        
        user.accessToken = User.currentUser?.accessToken
    
        DataProvider.sharedInstance.postBalance(user) { (balance, error) in
            
            self.dismissProgressHud()
            
            if let balance = balance {
                
                self.redemedLabel   .text = "- U$D \(balance.redemed!)"
                self.earnedLabel    .text = "U$D \(balance.earned!)"
                
                guard let earned = Double(balance.earned!) , redemed = Double(balance.redemed!) else {
                    return
                }
                
                self.accountMoneyLabel.text = "U$D \(earned - redemed)"
                
            } else if let error = error {
                self.showAlert(error)
            }
        }
    }

    // MARK: - Actions


}