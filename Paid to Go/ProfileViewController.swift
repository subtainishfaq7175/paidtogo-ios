//
//  ProfileViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 22/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: MenuContentViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var signupButtonViewContainer: UIView!
    
    // MARK: - Variables and Constants
    
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
  
        setNavigationBarVisible(true)
        self.title = "menu_profile".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    
        self.populateFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    

    // MARK: - Functions
    
    private func initViews(){
        signupButtonViewContainer.round()
        profileImageView.roundWholeView()
    }
    
    private func populateFields() {
        
        let currentUser         = User.currentUser!
        
        emailTextField.text     = currentUser.email
        firstNameTextField.text = currentUser.name
        lastNameTextField.text  = currentUser.lastName
        bioTextField.text       = currentUser.bio
      
        if let currentProfilePicture = currentUser.profilePicture {
        
            let base64String        = currentProfilePicture
                .stringByReplacingOccurrencesOfString(User.imagePrefix, withString: "")
        
            if let imageData           = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
        
                let profileImage        = UIImage(data: imageData)
        
                profileImageView.image  = profileImage
            }
            
        }



        
    }
    
    
    // MARK: - Actions
    
    func submitAction(sender: AnyObject?){
        log.debug("Profile changes submited")
    }
    
    
}