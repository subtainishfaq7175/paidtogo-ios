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
    
    @IBOutlet weak var requestButtonContainerView: UIView! {
        didSet {
             requestButtonContainerView.alpha = CGFloat(0.3)
             requestButtonContainerView.userInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var redemedLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!    
    @IBOutlet weak var accountMoneyLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            amountTextField.keyboardType = UIKeyboardType.DecimalPad
        }
    }
    
    // MARK: - Variables and Constants -
    
    var balance : Balance?
    
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
                
                self.balance = balance
                
                guard let earned = Double(balance.earned!),
                            redemed = Double(balance.redemed!),
                                pending = Double(balance.pending!) else {
                    return
                }

                self.redemedLabel.text = "- US$ \(String(format: "%.2f", redemed))"
                self.earnedLabel.text = "US$ \(String(format: "%.2f", earned))"
                self.pendingLabel.text = "US$ \(String(format: "%.2f", pending))"
                self.accountMoneyLabel.text = "US$ \(String(format: "%.2f", earned - redemed))"
                
            } else if let error = error {
                self.showAlert(error)
            }
        }
    }
    
    func validateAmount() -> Bool {
        
        if let amountString = amountTextField.text where amountTextField.text?.characters.count > 0 {
            if let amount = Double(amountString) {
                if let balance = self.balance?.balance {
                    let accountMoney = Double(balance)
                    
                    if amount > accountMoney {
                        self.showAlert("You don't have enough money in your account to redeem that amount")
                        return false
                    }
                    
                    return true
                }
                
                return false
                
            } else {
                self.showAlert("Please enter a valid amount")
                return false
            }
        } else {
            self.showAlert("Please enter a valid amount")
            return false
        }
    }

    func addPayPalAccountButtonPressed(alert: UIAlertAction!) {
        let profileVC = StoryboardRouter.initialProfileViewController()
        profileVC.menuController = self.menuController
        profileVC.shouldEnterPayPalAccount = true
        self.navigationController?.showViewController(profileVC, sender: nil)
        
    }
    
    func createPayPalAccountButtonPressed(alert: UIAlertAction!) {
        let url : NSURL = NSURL(string: "https://www.paypal.com")!
        
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func buttonRequestPressed(sender: AnyObject) {
        
        if !self.validateAmount() {
            return
        }
        
        let user = User.currentUser
        
        guard let _ = user?.paypalAccount where user?.paypalAccount?.characters.count > 0 else {
            
            amountTextField.resignFirstResponder()
            
            let alertController = UIAlertController(title: "PaidToGo", message: "You need to have a PayPal account associated to your PaidToGo user in order to redeem money", preferredStyle: UIAlertControllerStyle.Alert)
            
            let addPayPalAccountButton = UIAlertAction(title: "Enter PayPal account number", style: UIAlertActionStyle.Default, handler: addPayPalAccountButtonPressed)
            let createPayPalAccountButton = UIAlertAction(title: "Create PayPal account", style: UIAlertActionStyle.Default, handler: createPayPalAccountButtonPressed)
            let cancelPalAccountButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(addPayPalAccountButton)
            alertController.addAction(createPayPalAccountButton)
            alertController.addAction(cancelPalAccountButton)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.postPayment(amountTextField.text!, type: "Pending") { (error) in
            
            self.dismissProgressHud()
            
            if error == nil {
                self.showAlert("Redeemed Successfuly!!")
                
                guard let pending = Double(self.balance!.pending!), amount = Double(self.amountTextField.text!) else {
                    return
                }
                
                let pendingUpdated = amount + pending
                self.balance?.pending = String(format: "%.2f", pendingUpdated)
                
                self.pendingLabel.text = "US$ " + (self.balance?.pending)!
                
                self.amountTextField.text = ""
                self.amountTextField.resignFirstResponder()
            } else {
                self.showAlert("Transaction unsuccessful. There was a problem with the server, please try again later")
            }
        }
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        if let textField = sender as? UITextField {
            if textField.text?.characters.count > 0 {
                requestButtonContainerView.alpha = CGFloat(1)
                requestButtonContainerView.userInteractionEnabled = true
            } else {
                requestButtonContainerView.alpha = CGFloat(0.3)
                requestButtonContainerView.userInteractionEnabled = false
            }
        }
    }
    
}