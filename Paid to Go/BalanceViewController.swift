//
//  SettingsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class BalanceViewController: MenuContentViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var requestButtonContainerView: UIView!
    
    @IBOutlet weak var redemedLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var accountMoneyLabel: UILabel!
    
    // MARK: - Variables and Constants -
    
    
    // MARK: - Super -
    
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
    
    // MARK: - Functions -
    
    func initViews() {
        self.requestButtonContainerView.round()
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

    func addPayPalAccountButtonPressed(alert: UIAlertAction!) {
        
    }
    
    func createPayPalAccountButtonPressed(alert: UIAlertAction!) {
        let url : NSURL = NSURL(string: "https://www.paypal.com")!
        
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func buttonRequestPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "PaidToGo", message: "You need to have a PayPal account associated to your PaidToGo user in order to redeem money", preferredStyle: UIAlertControllerStyle.Alert)
        
        let addPayPalAccountButton = UIAlertAction(title: "Enter PayPal account number", style: UIAlertActionStyle.Default, handler: addPayPalAccountButtonPressed)
        let createPayPalAccountButton = UIAlertAction(title: "Create PayPal account", style: UIAlertActionStyle.Default, handler: createPayPalAccountButtonPressed)
        alertController.addAction(addPayPalAccountButton)
        alertController.addAction(createPayPalAccountButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}