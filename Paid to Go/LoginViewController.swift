//
//  ViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 15/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: ViewController {
    
    //MARK: - Variables and constants
    @IBOutlet weak var usernameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var loginViewContainer: UIView!
    @IBOutlet weak var facebookViewContainer: UIView!
    @IBOutlet weak var signupViewContainer: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    
    // MARK: - Super
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initConstraints()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        initViews()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(false)
        
        verifyIfThereIsCurrentUser()
    }
    
    private func verifyIfThereIsCurrentUser() {
        if let _ = User.currentUser {
            presentHomeViewControllerWithoutAnimation()
        }
    }
    
    // MARK: - Actions
    @IBAction func loginButtonAction(sender: AnyObject) {
        
        if(validate()) {
            
            self.showProgressHud()
            
            let newUser: User   = User()
            
            newUser.email       = usernameTextField.text
            newUser.password    = passwordTextField.text
            
            DataProvider.sharedInstance.postLogin(newUser, completion: { (user, error) in
                self.dismissProgressHud()
                
                if let error = error where error.isEmpty == false {
                    self.showAlert(error)
                    return
                }
                
                if error == nil && user != nil {
                    
                    User.currentUser = user
                    
                    self.presentHomeViewController()
                    
                }
            })
        }
    }
    
    @IBAction func facebookButtonAction(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager.init()
        
        let loginPermissions = ["public_profile", "email"]
        
        loginManager.logInWithReadPermissions(loginPermissions, fromViewController: self) { (result, error) in
            if let error = error {
                print("Facebook Login Error: ",  error)
            } else {
                
                if let token = result.token {
                    
                    let tokenString = token.tokenString
                    
                    let params = ["social_token" : tokenString]
                    
                    self.showProgressHud()
                    
                    DataProvider.sharedInstance.postFacebookLogin(params, completion: { (user, error) in
                        self.dismissProgressHud()
                        
                        if let error = error where error.isEmpty == false {
                            self.showAlert(error)
                            return
                        }
                        
                        if error == nil && user != nil {
                            
                            User.currentUser = user
                            
                            self.presentHomeViewController()
                            
                        }
                    })
                    
                }
            }
        }
    }
    
    // MARK: - Functions
    
    private func validate() -> Bool {
        if usernameTextField.text == "" {
            showAlert("Username field is empty")
            return false
        }
        if passwordTextField.text == "" {
            showAlert("Password field is empty")
            return false
        }
        
        return true
    }
    
    private func initConstraints(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        switch screenSize.height {
        case _ where screenSize.height >= 736.0: // iPhone 6 Plus
            updateTopAndBottomConstraints(0.5)
            break
        case 667.0: // iPhone 6
            updateTopAndBottomConstraints(0.25)
            break
        default:
            break
        }
        
        
    }
    
    private func initViews(){
        loginViewContainer.round()
        facebookViewContainer.round()
        signupViewContainer.round()
        
        
    }
    
    
    private func updateTopAndBottomConstraints(multiplier: CGFloat){
        usernameTopConstraint.constant = usernameTopConstraint.constant + usernameTopConstraint.constant * multiplier
        
        forgotPasswordBottomConstraint.constant = forgotPasswordBottomConstraint.constant + forgotPasswordBottomConstraint.constant * multiplier
    }
    
    
    
    
}

