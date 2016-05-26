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
    
    @IBOutlet weak var addPictureImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var signupButtonViewContainer: UIView!
    
    // MARK: - Variables and Constants
    
    var profileImage: UIImage?
    
    
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
        
        emailTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        bioTextField.delegate = self
        
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
            
            print(currentProfilePicture)
            
            addPictureImageView.hidden = true
            
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), placeholder: UIImage(named: "ic_profile_placeholder"))
            //            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), options: .RefreshImageCache)
            
            //            let base64String        = currentProfilePicture
            //                .stringByReplacingOccurrencesOfString(User.imagePrefix, withString: "")
            //
            //            if let imageData           = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
            //
            //                let profileImage        = UIImage(data: imageData)
            //
            //                profileImageView.image  = profileImage
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
        
        //        if passwordTextField.text! == "" {
        //            showAlert("Password field is empty")
        //            return false
        //        }
        //        if passwordVerificationTextField.text! == "" {
        //            showAlert("Password verification field is empty")
        //            return false
        //        }
        //        if passwordTextField.text != passwordVerificationTextField.text {
        //            showAlert("The passwords don't match")
        //            return false
        //        }
        
        if bioTextField.text! == "" {
            showAlert("Biography field is empty")
            return false
        }
        
        //        if profileImage == nil {
        //            showAlert("A profile image shall be upload")
        //            return false
        //        }
        
        
        return true
    }
    
    
    
    // MARK: - Selectors
    
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
                
                let imageData = UIImagePNGRepresentation(profileImage)
                
                let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                
                let encodedImageWithPrefix = User.imagePrefix + base64String
                
                userToSend.profilePicture = encodedImageWithPrefix
            }
            
            
            DataProvider.sharedInstance.postUpdateProfile(userToSend) { (user, error) in
                
                self.dismissProgressHud()
                
                if let user = user { //success
                    
                    self.showAlert("profile_changes_submited".localize())
                    
                    self.profileImageView.yy_setImageWithURL(NSURL(string: (User.currentUser?.profilePicture)!), options: .RefreshImageCache)
                    
                    User.currentUser = user
                    
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        if string == "\n" {
//            textField.resignFirstResponder()
//        }
//        
//        return true
//    }
}
