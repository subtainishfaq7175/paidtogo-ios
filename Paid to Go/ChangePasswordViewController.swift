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
    
    }
    
}
