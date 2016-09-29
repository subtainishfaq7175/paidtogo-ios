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
    
    var tokenFB : String?
    
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
        
        if let user = User.currentUser {
            guard let _ = user.userId else {
                return
            }
            
            verifyProUserSubscription(user)
        }
    }
    
    /**
     We verify, if the user has a currently active subscription, that the subscription is still valid
     
     - parameter user: the user
     */
    private func verifyProUserSubscription(user:User) {
        
        if user.isPro() && user.hasPaymentToken() {
            // If the user is a Pro User and has a paymentToken, we validate with the Apple API if the subscription is still in course
            DataProvider.sharedInstance.postValidateProUser({ (error) in
                if let _ = error {
                    // Post Pro User expired notification
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NotificationsHelper.ProUserSubscriptionExpired.rawValue, object: nil))
                }
            })
        }
        
        presentHomeViewController()
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
                    
                    self.verifyProUserSubscription(user!)
                }
            })
        }
    }
    
    @IBAction func facebookButtonAction(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager.init()
        
        let loginPermissions = ["public_profile", "email"]
        
        loginManager.logInWithReadPermissions(loginPermissions, fromViewController: self) { (result, error) in
            if let error = error {
                self.showAlert(error.description)
                print("Facebook Login Error: ",  error)
            } else {
                
                if let token = result.token {
                    
                    self.tokenFB = token.tokenString
                    
                    loginManager.logOut()
                    
                    self.loginFB(true)
                }
            }
        }
    }
    
    func loginFB(firstTry: Bool) {
        
        let params = ["social_token" : self.tokenFB!]
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.postFacebookLogin(params, completion: { (user, error) in
            self.dismissProgressHud()
            
            if let error = error where error.isEmpty == false {
                if firstTry {
                    self.loginFB(false)
                } else {
                    self.showAlert(error)
                }
                return
            }
            
            if error == nil && user != nil {
                
                User.currentUser = user
                
                self.verifyProUserSubscription(user!)
                
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
//        if segue.identifier == "segue_signup" {
//            if let destinationNC = segue.destinationViewController as? NavigationController {
//                if let destinationVC = destinationNC.viewControllers[0] as? SignupViewController {
//                    destinationVC.delegate = self
//                }
//            }
//        }
    }
    
    // MARK: - Functions
    
    private func validate() -> Bool {
        if usernameTextField.text == "" {
            showAlert("alert_username_empty".localize())
            return false
        }
        if passwordTextField.text == "" {
            showAlert("alert_password_empty".localize())
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

