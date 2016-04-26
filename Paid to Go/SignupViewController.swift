//
//  SignupViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 16/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class SignupViewController: ViewController {
    
    @IBOutlet weak var signupButtonViewContainer: UIView!
    @IBOutlet weak var registerPhotoImageView: UIImageView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var termsAndConditionsSwitch: UISwitch!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var termsSwitch: UISwitch!
    
    var profileImage: UIImage?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(true)
        self.title = "Sign Up"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = "test@test.test1"
        firstNameTextField.text = "test"
        lastNameTextField.text = "test"
        passwordVerificationTextField.text = "test123"
        passwordTextField.text = "test123"
        bioTextField.text = "test"
        
        setNavigationBarGreen()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    private func initViews(){
        signupButtonViewContainer.round()
        registerPhotoImageView.roundWholeView()
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
        if passwordTextField.text! == "" {
            showAlert("Password field is empty")
            return false
        }
        if passwordVerificationTextField.text! == "" {
            showAlert("Password verification field is empty")
            return false
        }
        if passwordTextField.text != passwordVerificationTextField.text {
            showAlert("The passwords don't match")
            return false
        }
        if bioTextField.text! == "" {
            showAlert("Biography field is empty")
            return false
        }
        if !termsSwitch.on {
            showAlert("The terms and conditions shall be accepted")
            return false
        }
        if profileImage == nil {
            showAlert("A profile image shall be upload")
            return false
        }
        
        
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
    
    @IBAction func signup(sender: AnyObject) {
  
        self.showProgressHud("Loading") // TODO: Fix delay 
        
        if(self.validate()) {
            
            let newUser: User   = User()
            newUser.email       = emailTextField.text!
            newUser.name        =  firstNameTextField.text!
            newUser.lastName    = lastNameTextField.text!
            newUser.password    = passwordTextField.text!
            newUser.bio         = bioTextField.text!
            
            let imageData = UIImagePNGRepresentation(profileImage!)
            
            let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            let encodedImageWithPrefix = "data:image/jpeg;base64," + base64String
            
            newUser.profilePicture = encodedImageWithPrefix
            
            
            DataProvider.sharedInstance.postRegister(newUser, completion: { (user: User?, error: String?) in
                
                self.dismissProgressHud()
                
                if let error = error where error.isEmpty == false {
                    self.showAlert(error)
                    return
                }
                
                if error == nil && user != nil {
                    
                    newUser.accessToken = user!.accessToken
                    newUser.userId = user!.userId
                    
                    // TODO: Save newUser on a singleton instance locally stored (similar to UserManager used on Android)
                    
                    self.presentHomeViewController()
                    
                }
                
            })
        } else {
            dismissProgressHud()
        }
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImage = image
        
        self.registerPhotoImageView.image = image
        self.addImageView.hidden = true
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
    
}
