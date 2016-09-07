//
//  ProViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 6/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class ProViewController: ViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK: - View life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setBorderToView(self.acceptButton, color: UIColor.whiteColor().CGColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions -
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    @IBAction func acceptButtonAction(sender: AnyObject) {
        print("Go Pro")
        
        self.showProgressHud()
        ProUser.store.requestProducts { (success, products) in
            self.dismissProgressHud()
            
            if success {
                print("Product: \(products)")
                
                let userToSend = User()
                userToSend.accessToken = User.currentUser?.accessToken
                userToSend.type = UserType.Pro.rawValue
                
                DataProvider.sharedInstance.postUpdateProfile(userToSend) { (user, error) in
                    self.dismissProgressHud()
                    
                    if let user = user { //success
                        
                        User.currentUser = user
                        self.showAlert("Congratulations!! You became a Pro User")
                        
                        
                    } else if let error = error {
                        
                        self.showAlert(error)
                    }
                }
                
            } else {
                print("Error - IAP Failed to get autorenewable subscription")
            }
        }
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
