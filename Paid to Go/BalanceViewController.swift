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
            requestButtonContainerView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var redemedLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!    
    @IBOutlet weak var accountMoneyLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            amountTextField.keyboardType = UIKeyboardType.decimalPad
        }
    }
    
    // MARK: - Variables and Constants -
    
    var balance : Balance?
    
    // MARK: - Super -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(visible: true)
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
    
//        DataProvider.sharedInstance.postBalance(user) { (balance, error) in
//
//            self.dismissProgressHud()
//
//            if let balance = balance {
//
//                self.balance = balance
//
//                guard let earned = Double(balance.earned!),
//                    let redemed = Double(balance.redemed!),
//                    let pending = Double(balance.pending!) else {
//                    return
//                }
//
//                self.redemedLabel.text = "- US$ \(String(format: "%.2f", redemed))"
//                self.earnedLabel.text = "US$ \(String(format: "%.2f", earned))"
//                self.pendingLabel.text = "US$ \(String(format: "%.2f", pending))"
//                self.accountMoneyLabel.text = "US$ \(String(format: "%.2f", earned - redemed))"
//
//            } else if let error = error {
//                self.showAlert(error)
//            }
//        }
    }
    
    func validateAmount() -> Bool {
        
        if let amountString = amountTextField.text, let text = amountTextField.text {
            if text != ""{
                if let amount = Double(amountString) {
                    if let balance = self.balance?.balance {
                        let accountMoney = Double(balance)
                        
                        if amount > accountMoney {
                            self.showAlert(text: "You don't have enough money in your account to redeem that amount")
                            return false
                        }
                        
                        return true
                    }
                    
                    return false
                    
                } else {
                    self.showAlert(text: "Please enter a valid amount")
                    return false
                }
            }
            
        } else {
            self.showAlert(text: "Please enter a valid amount")
            return false
        }
        return false
    }

    func addPayPalAccountButtonPressed(alert: UIAlertAction!) {
        let profileVC = StoryboardRouter.initialProfileViewController()
        profileVC.menuController = self.menuController
        profileVC.shouldEnterPayPalAccount = true
        self.navigationController?.show(profileVC, sender: nil)
        
    }
    
    func createPayPalAccountButtonPressed(alert: UIAlertAction!) {
        let url : URL = URL(string: "https://www.paypal.com")!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func buttonRequestPressed(sender: AnyObject) {
        
        if !self.validateAmount() {
            return
        }
        
        let user = User.currentUser
        
        guard let payPayAccount = user?.paypalAccount, payPayAccount != ""  else {
            
            amountTextField.resignFirstResponder()
            
            let alertController = UIAlertController(title: "PaidToGo", message: "You need to have a PayPal account associated to your PaidToGo user in order to redeem money", preferredStyle: UIAlertControllerStyle.alert)
            
            let addPayPalAccountButton = UIAlertAction(title: "Enter PayPal account number", style: UIAlertActionStyle.default, handler: addPayPalAccountButtonPressed)
            let createPayPalAccountButton = UIAlertAction(title: "Create PayPal account", style: UIAlertActionStyle.default, handler: createPayPalAccountButtonPressed)
            let cancelPalAccountButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(addPayPalAccountButton)
            alertController.addAction(createPayPalAccountButton)
            alertController.addAction(cancelPalAccountButton)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        self.showProgressHud()
        
//        DataProvider.sharedInstance.postPayment(amountTextField.text!, type: "Pending") { (error) in
//            
//            self.dismissProgressHud()
//            
//            if error == nil {
//                self.showAlert("Redeemed Successfuly!!")
//                
//                guard let pending = Double(self.balance!.pending!), amount = Double(self.amountTextField.text!) else {
//                    return
//                }
//                
//                let pendingUpdated = amount + pending
//                self.balance?.pending = String(format: "%.2f", pendingUpdated)
//                
//                self.pendingLabel.text = "US$ " + (self.balance?.pending)!
//                
//                self.amountTextField.text = ""
//                self.amountTextField.resignFirstResponder()
//            } else {
//                self.showAlert("Transaction unsuccessful. There was a problem with the server, please try again later")
//            }
//        }
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        if let textField = sender as? UITextField {
            if textField.text != "" {
                requestButtonContainerView.alpha = CGFloat(1)
                requestButtonContainerView.isUserInteractionEnabled = true
            } else {
                requestButtonContainerView.alpha = CGFloat(0.3)
                requestButtonContainerView.isUserInteractionEnabled = false
            }
        }
    }
    
}
