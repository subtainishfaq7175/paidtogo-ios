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
    @IBOutlet weak var paypalTextField: UITextField!
    
    @IBOutlet weak var signupButtonViewContainer: UIView!
    
    @IBOutlet weak var proUserLabel: UILabel!
    
    // MARK: - Variables and Constants -
    
    var profileImage: UIImage?
    var shouldEnterPayPalAccount = false
    
    // MARK: - Test
    
    var userIsPro = false
    
    // MARK: - Super -
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        self.title = "menu_profile".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
        
        if shouldEnterPayPalAccount {
            self.paypalTextField.becomeFirstResponder()
        }
        
        configureViewForProUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        bioTextField.delegate = self
        paypalTextField.delegate = self
        
        self.populateFields()
        
        self.signUpButtonShouldChange(false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    // MARK: - Functions -
    
    func configureViewForProUser() {
        let user = User.currentUser!
        
        if let userType = user.type {
            
            if userType.characters.count > 0 && userType == "1" {
                // Pro User
                proUserLabel.hidden = false
            } else {
                proUserLabel.hidden = true
            }
        } else {
            proUserLabel.hidden = true
        }
    }
    
    private func initViews(){
        signupButtonViewContainer.round()
        proUserLabel.round()
        profileImageView.roundWholeView()
    }
    
    private func populateFields() {
        
        let currentUser         = User.currentUser!
        
        emailTextField.text     = currentUser.email
        firstNameTextField.text = currentUser.name
        lastNameTextField.text  = currentUser.lastName
        bioTextField.text       = currentUser.bio
        
        if let currentProfilePicture = currentUser.profilePicture {
            
            print(currentProfilePicture)
            
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), placeholder: UIImage(named: "ic_profile_placeholder"))
        }
    }
    
    private func validate() -> Bool {
        
        if emailTextField.text! == "" {
            showAlert("Email field is empty")
            return false
        }
        if firstNameTextField.text! == "" {
            showAlert("First name field is empty")
            return false
        }
        if lastNameTextField.text! == "" {
            showAlert("Last Name field is empty")
            return false
        }
        
        if bioTextField.text! == "" {
            showAlert("Biography field is empty")
            return false
        }
        
        return true
    }
    
    func signUpButtonShouldChange(value: Bool) {
        if value == true {
            enableSignUpButton()
        } else {
            disableSignUpButton()
        }
    }
    
    func enableSignUpButton() {
        signupButtonViewContainer.alpha = CGFloat(1.0)
        signupButtonViewContainer.userInteractionEnabled = true
    }
    
    func disableSignUpButton() {
        signupButtonViewContainer.alpha = CGFloat(0.3)
        signupButtonViewContainer.userInteractionEnabled = false
    }
    
    // MARK: - Selectors -
    
    @IBAction func photoTapAction(sender: AnyObject) {
        
        let photoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        photoActionSheet.addAction(UIAlertAction(title: "auth_photo_camera_option".localize(), style: .Default, handler: {
            action in
            
            self.takePhotoFromCamera()
        }))
        photoActionSheet.addAction(UIAlertAction(title: "auth_photo_library_option".localize(), style: .Default, handler: {
            action in
            
            self.takePhotoFromGallery()
        }))
        photoActionSheet.addAction(UIAlertAction(title: "cancel".localize(), style: .Cancel, handler: nil))
        self.presentViewController(photoActionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        
        User.logout()
        self.logoutAnimated()
        
    }
    
    @IBAction func submitAction(sender: AnyObject?){
        
        if validate() {
            
            self.showProgressHud()
            
            let userToSend: User!
            userToSend = User()
            
            userToSend.accessToken = User.currentUser?.accessToken
            userToSend.name = firstNameTextField.text
            userToSend.lastName = lastNameTextField.text
            userToSend.bio = bioTextField.text
            
            if let profileImage = profileImage {
                
                let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
                let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                let encodedImageWithPrefix = User.imagePrefix + base64String
                
                userToSend.profilePicture = encodedImageWithPrefix
            }
            
            DataProvider.sharedInstance.postUpdateProfile(userToSend) { (user, error) in
                
                self.dismissProgressHud()
                
                if let user = user { //success
                    
                    self.showAlert("profile_changes_submited".localize())
                    
//                    self.profileImageView.yy_setImageWithURL(NSURL(string: (User.currentUser?.profilePicture)!), options: .RefreshImageCache)
                    self.profileImageView.yy_setImageWithURL(NSURL(string: user.profilePicture!), placeholder: UIImage(named: "ic_profile_placeholder"))
                    
                    User.currentUser = user
                    
                    let notificationName = NotificationsHelper.UserProfileUpdated.rawValue
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notificationName, object: nil))
                    
                    self.signUpButtonShouldChange(false)
                    
                    if self.paypalTextField.text?.characters.count > 0 {
                        let user = User.currentUser
                        user!.paypalAccount = self.paypalTextField.text
                        User.currentUser = user
                    }
                    
                } else if let error = error {
                    
                    self.showAlert(error)
                    
                }
            }
        }
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImage = image
        
        self.profileImageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil);
        
        self.signUpButtonShouldChange(true)
    }
    
    func takePhotoFromCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            let picker = UIImagePickerController();
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            picker.allowsEditing = true;
            
            self.presentViewController(picker, animated: true, completion: nil);
        }
    }
    
    func takePhotoFromGallery (){
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
            
            let picker = UIImagePickerController();
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            picker.allowsEditing = true;
            
            self.presentViewController(picker, animated: true, completion: nil);
        }
    }

    @IBAction func textFieldEditingChanged(sender: AnyObject) {
        self.signUpButtonShouldChange(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        /*
        if textField == paypalTextField && textField.text?.characters.count > 0 {
            
            let user = User.currentUser
            user!.paypalAccount = textField.text
            User.currentUser = user
        }
         */
        
        return true
    }
}
