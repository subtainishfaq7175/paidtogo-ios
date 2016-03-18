//
//  ViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 15/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class LoginViewController: ViewController {
    
    //MARK: - Variables and constants
    @IBOutlet weak var usernameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var loginViewContainer: UIView!
    @IBOutlet weak var facebookViewContainer: UIView!
    @IBOutlet weak var signupViewContainer: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
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
    }
    
    // MARK: - Actions
    @IBAction func loginButtonAction(sender: AnyObject) {
        //Validate
        if usernameTextField.text == "" {
            showAlert("Username field is empty")
            return
        }
        if passwordTextField.text == "" {
            showAlert("Password field is empty")
            return
        }
        
        
        presentHomeViewController()
    }
    
    @IBAction func facebookButtonAction(sender: AnyObject) {
        presentHomeViewController()
    }
    
    // MARK: - Functions
    
    private func presentHomeViewController(){
        self.presentViewController(StoryboardRouter.menuMainViewController(), animated: true, completion: nil)
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

