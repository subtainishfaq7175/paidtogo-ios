//
//  ChangePasswordViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 6/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var changePasswordButtonView: UIView!
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    // MARK: - View life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Change Password"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.changePasswordButtonView.round()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions -
    
    @IBAction func changePasswordButtonAction(sender: AnyObject) {
    
        self.showAlert(text: "Under Development")
        return;
        
        self.view.endEditing(true)
        
        if validateNewPassword() {
            
            if let newPassword = self.newPasswordTextField.text {
                let userToSend = User()
                userToSend.accessToken = User.currentUser?.accessToken
                userToSend.password = newPassword
                
                self.showProgressHud()
                DataProvider.sharedInstance.postUpdateProfile(user: userToSend) { (user, error) in
                    self.dismissProgressHud()
                    
                    if let err = error {
                        print("Error \(err)")
                        return
                    }
                    
                    if let user = user {
                        User.currentUser = user
                        
                        /*
                        // Dismiss screen first, then show message
                         
                        let previousVC = self.navigationController?.viewControllers.first as! SettingsViewController
                        self.navigationController?.popViewController(true, completion: {
                            previousVC.showAlert("Password updated successfuly!!")
                        })
                         */
                        
                        self.showAlertAndDismissOnCompletion(text: "Password updated successfuly!!")
                    }
                }
            }
            
        }
    }
    
    // MARK: - Methods -
    
    func validateNewPassword() -> Bool {
        
        if let newPassword = self.newPasswordTextField.text, newPassword.isEmpty == false,
            let confirmNewPassword = self.confirmNewPasswordTextField.text, confirmNewPassword.isEmpty == false {
            
            if newPassword == confirmNewPassword {
                return true
            } else {
                self.showAlert(text: "You must enter the same password twice in order to confirm it")
                return false
            }
            
        } else {
            self.showAlert(text: "Please complete all fields")
            return false
        }
        
    }
}
