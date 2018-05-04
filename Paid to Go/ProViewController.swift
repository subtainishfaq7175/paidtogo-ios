//
//  ProViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 6/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import StoreKit

class ProViewController: ViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Variables and constants
    
    var productsRequest:SKProductsRequest = SKProductsRequest()
    
    // MARK: - View life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let image = UIImage(named: "ic_close")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate) {
            self.closeButton.setImage(image, for: .normal)
            self.closeButton.tintColor = UIColor.white
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(notification:)), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setBorderToView(view: self.acceptButton, color: UIColor.white.cgColor)
        self.setBorderToView(view: self.cancelButton, color: UIColor.white.cgColor)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInAppPurchase() {
        
        self.showProgressHud()
        ProUser.store.requestProducts { (success, products) in
            self.dismissProgressHud()
            
            if success {
                print("Product: \(products)")
                
                if let autorenewableSubscription = products?.first {
                    ProUser.store.buyProduct(product: autorenewableSubscription)
                }
                
            } else {
                print("Error - IAP Failed to get autorenewable subscription")
                self.showAlert(text: "Pro User subscription failed")
            }
        }
    }
    
    func becomePro() {
        
        let userToSend = User()
        userToSend.accessToken = User.currentUser?.accessToken
        userToSend.type = UserType.Pro.rawValue
//        userToSend.paymentToken = AppleInAppValidator.getReceiptData()
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.postUpdateProfile(user: userToSend) { (user, error) in
            self.dismissProgressHud()
            
            if let user = user { //success
                
                User.currentUser = user
                self.showAlertAndDismissModallyOnCompletion(text: "Congratulations!! You became a Pro User")
                
            } else if let error = error {
                
                self.showAlert(text: error)
            }
        }
    }
    
    @objc func handlePurchaseNotification(notification: NSNotification) {
        becomePro()
    }
    
    // MARK: - Actions -
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func acceptButtonAction(sender: AnyObject) {
        handleInAppPurchase()
    }
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
