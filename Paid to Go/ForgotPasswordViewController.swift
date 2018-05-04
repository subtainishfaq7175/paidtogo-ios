//
//  ForgotPasswordViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 18/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: ViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButtonViewContainer: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(visible: true)
        self.title = "password_recover_title".localize()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarGreen()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    private func initViews(){
        submitButtonViewContainer.round()
    
    }
    
    private func validate() -> Bool {
        if emailTextField.text == "" {
            showAlert(text: "An email address shall be specified")
            return false
        }
        
        return true
    }
    
    @IBAction func recoverPassword(sender: AnyObject) {
        
        if validate() {
            
            self.showProgressHud()
            
            let user = User()
            user.email = emailTextField.text
            
            DataProvider.sharedInstance.postRecoverPassword(user: user, completion: { (genericResponse, error) in
                self.dismissProgressHud()

                if let error = error, error.isEmpty == false {
                    self.showAlert(text: error)
                    return
                }
                
                if error == nil && genericResponse != nil {

                    if genericResponse?.code == "PASSWORD_RECOVERED" {
                        self.showAlert(text: "password_recovered".localize())
                    }

                }
            })
        }
        
    }
    
  
}
