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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(true)
        self.title = "Password Recovery"
        
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
    
  
}
