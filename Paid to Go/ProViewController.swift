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
        if let image = UIImage(named: "ic_close")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) {
            self.closeButton.setImage(image, forState: .Normal)
            self.closeButton.tintColor = UIColor.whiteColor()
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: IAPHelper.IAPHelperPurchaseNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setBorderToView(self.acceptButton, color: UIColor.whiteColor().CGColor)
        self.setBorderToView(self.cancelButton, color: UIColor.whiteColor().CGColor)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
                    ProUser.store.buyProduct(autorenewableSubscription)
                }
                
            } else {
                print("Error - IAP Failed to get autorenewable subscription")
                self.showAlert("Pro User subscription failed")
            }
        }
    }
    
    func becomePro() {
        
        let userToSend = User()
        userToSend.accessToken = User.currentUser?.accessToken
        userToSend.type = UserType.Pro.rawValue
        userToSend.paymentToken = AppleInAppValidator.getReceiptData()
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.postUpdateProfile(userToSend) { (user, error) in
            self.dismissProgressHud()
            
            if let user = user { //success
                
                User.currentUser = user
                self.showAlertAndDismissModallyOnCompletion("Congratulations!! You became a Pro User")
                
            } else if let error = error {
                
                self.showAlert(error)
            }
        }
    }
    
    func handlePurchaseNotification(notification: NSNotification) {
        becomePro()
    }
    
    // MARK: - Actions -
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    @IBAction func acceptButtonAction(sender: AnyObject) {
        handleInAppPurchase()
    }
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
