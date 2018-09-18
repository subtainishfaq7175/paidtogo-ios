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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(visible: false)
    }
    
    
    // MARK: - Actions
    @IBAction func loginButtonAction(sender: AnyObject) {
                
        if(validate()) {
            
            self.showProgressHud()
            
            let newUser: User   = User()
            
            newUser.email       = usernameTextField.text
            newUser.password    = passwordTextField.text
            
            DataProvider.sharedInstance.postLogin(user: newUser, completion: { (user, error) in
                self.dismissProgressHud()

                if let error = error, error.isEmpty == false {
                    self.showAlert(text: error)
                    return
                }

                if error == nil && user != nil {

                    User.currentUser = user

                    self.verifyProUserSubscription(user: user!)
                }
            })
        }
    }
    
    @IBAction func facebookButtonAction(sender: AnyObject) {
        
//        self.showAlert(text: "Under Development")
//        return;
        
        let loginManager = FBSDKLoginManager.init()
        
        let loginPermissions = ["public_profile", "email"]
        
        loginManager.logIn(withReadPermissions: loginPermissions, from: self) { (result, error) in
            
            if let error = error {
                self.showAlert(text: error.localizedDescription)
                print("Facebook Login Error: ",  error)
            } else {
                
                if let token = result?.token {
                    
                    self.tokenFB = token.tokenString
                    
                    loginManager.logOut()
                    
                    self.loginFB(firstTry: true)
                }
            }
        }
    }
    
    func loginFB(firstTry: Bool) {
        self.showProgressHud()
        
        let req = FBSDKGraphRequest(graphPath: "me", parameters:["fields": "id, name, first_name, last_name, email,picture.type(large)"], tokenString: self.tokenFB!, version: nil, httpMethod: "GET")

        req?.start(completionHandler: { (connection, result, error) in
            self.dismissProgressHud()
            
            if(error == nil)
            {
                print("result \(result ?? "")")
                
                let info = result as! NSDictionary
                
                let newUser: User = User()
                
                if let imageURL = ((info.value(forKey: "picture") as? NSDictionary)?.value(forKey: "data") as? NSDictionary)?.value(forKey: "url") as? String {
                    //Download image from imageURL
                    newUser.facebookImageUrl = imageURL
                }
                
                if let id = info.value(forKey: "id") as? String {
                    newUser.facebookId = id
                }
                
                if let first_name = info.value(forKey: "first_name") as? String {
                    newUser.name = first_name
                }
                
                if let last_name = info.value(forKey: "last_name") as? String {
                    newUser.lastName = last_name
                }
                
                if let email = info.value(forKey: "email") as? String {
                    newUser.email = email
                }
                
                self.loginViaFacebook(with: newUser)
                
            }
            else
            {
                self.showAlert(text: (error?.localizedDescription)!)
            }
        })
        
    }
    
    
    func loginViaFacebook(with user: User) {
        self.showProgressHud(title: "Connecting with your Facebook")
        DataProvider.sharedInstance.postLoginViaFacebook(user: user, completion: { (user, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.showAlert(text: error)
                return
            }
            
            if error == nil && user != nil {
                
                User.currentUser = user
                
                self.verifyProUserSubscription(user: user!)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
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
            showAlert(text: "alert_username_empty".localize())
            return false
        }
        if passwordTextField.text == "" {
            showAlert(text: "alert_password_empty".localize())
            return false
        }
        
        return true
    }
    
    private func initConstraints(){
        let screenSize: CGRect = UIScreen.main.bounds
        
        switch screenSize.height {
        case _ where screenSize.height >= 736.0: // iPhone 6 Plus
            updateTopAndBottomConstraints(multiplier: 0.5)
            break
        case 667.0: // iPhone 6
            updateTopAndBottomConstraints(multiplier: 0.25)
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
    
    /**
     We verify, if the user has a currently active subscription, that the subscription is still valid
     
     - parameter user: the user
     */
    private func verifyProUserSubscription(user:User) {
        
        if user.isPro() && user.hasPaymentToken() {
            // If the user is a Pro User and has a paymentToken, we validate with the Apple API if the subscription is still in course
            DataProvider.sharedInstance.postValidateProUser(completion: { (error) in
                if let _ = error {
                    // Post Pro User expired notification
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationsHelper.ProUserSubscriptionExpired.rawValue), object: nil)
                    
                    //                    NotificationCenter.default.postNotification(NSNotification(name: NSNotification.Name(rawValue: NotificationsHelper.ProUserSubscriptionExpired.rawValue), object: nil))
                }
            })
        }
        
        presentHomeViewController()
    }
    
}

