//
//  SignupViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 16/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class SignupViewController: ViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarGreen()
        self.title = "Sign Up"
//        initViews()
    }

}