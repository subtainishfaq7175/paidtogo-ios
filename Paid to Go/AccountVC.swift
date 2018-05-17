//
//  AccountVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 14/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class AccountVC: BaseVc {
// user profile data connections
    @IBOutlet weak var userFirstNameTF: UITextField!
    @IBOutlet weak var userLastNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
//    payment method connections
    @IBOutlet weak var addAccountView: GenCustomView!
//    change password connections
    @IBOutlet weak var changePasswordLB: UILabel!
    
    @IBOutlet weak var okBtnOL: UIButton!
    @IBAction func okAction(_ sender: Any) {
        updateUserProfile()
    }
    
    
    var checkmarksStruct = CheckmarkStruct()
    var profileImage: UIImage?
    var picDelegate:ProfileDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
//        add tap gesture recognizer for add account and change password
        addAccountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelTap(_:))))
        changePasswordLB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelTap(_:))))
    }
    override func viewDidLayoutSubviews() {
        okBtnOL.round()
    }
//    fetch user stored data from local database
    func fetchUserData(){
        if let firstName = User.currentUser?.name {
            userFirstNameTF.text = firstName
        }
        if let lastName = User.currentUser?.lastName {
            userLastNameTF.text = lastName
        }
        if let email = User.currentUser?.email {
            userEmailTF.text = email
        }
    }
    
//    handel tap gesture
    @objc func handelTap(_ gesture:UIGestureRecognizer)  {
        guard let gestureView = gesture.view else {
            return
        }
        switch gestureView {
        case addAccountView:
            print("payment account taped")
            break
        case changePasswordLB:
            print("change password taped")
            break
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK: - UPDATE PROFILE
    private func validate() -> Bool {
        
//        if userEmailTF.text! == "" {
//            showAlert("Email field is empty")
//            return false
//        }
        if userFirstNameTF.text! == "" {
            showAlert( "First name field is empty")
            return false
        }
        if userLastNameTF.text! == "" {
            showAlert( "Last Name field is empty")
            return false
        }
        
        //        if bioTextField.text! == "" {
        //            showAlert("Biography field is empty")
        //            return false
        //        }
        
        return true
    }
    func updateUserProfile(){
        if validate() {
            
            self.showProgressHud()
            
            let userToSend: User!
            userToSend = User()
            
            userToSend.accessToken = User.currentUser?.accessToken
            userToSend.name = userFirstNameTF.text
            userToSend.lastName = userLastNameTF.text
            
//            if let paypalAcount = self.paypalTextField.text, self.paypalTextField.text != "" {
//                userToSend.paypalAccount = paypalAcount
//            }
            
                        if let profileImage = profileImage {

                            let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
            //                (.Encoding64CharacterLineLength)
                            let base64String = imageData!.base64EncodedString(options: .lineLength64Characters)
//                            imageData!.base64EncodedData(options: .lineLength64Characters)
//                            (options: .encoding64CharacterLineLength)
                            let encodedImageWithPrefix = User.imagePrefix + base64String

                            userToSend.profilePicture = encodedImageWithPrefix
                        }
            
            DataProvider.sharedInstance.postUpdateProfile(user: userToSend) { (user, error) in
            
                            self.dismissProgressHud()
            
                            if let user = user { //success
            
                                self.showAlert("profile_changes_submited".localize())
            
//                                self.profileImageView.yy_setImageWithURL(NSURL(string: user.profilePicture!), placeholder: UIImage(named: "ic_profile_placeholder"))
            
                                // We persist the user's personal options locally
            //                    user.profileOption1 = (User.currentUser?.profileOption1)!
            //                    user.profileOption2 = (User.currentUser?.profileOption2)!
            //                    user.profileOption3 = (User.currentUser?.profileOption3)!
            
//                                if let age = self.ageTextField.text where !age.isEmpty {
//                                    user.age = age
//                                }
            
//                                if let gender = self.genderTextField.text where !gender.isEmpty {
//                                    user.gender = gender
//                                }
            
                                User.currentUser = user
                                self.checkmarksStruct.updateUserLocally()
            
                                let notificationName = NotificationsHelper.UserProfileUpdated.rawValue
                                NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: nil)
//                                    Notification(name: notificationName, object: nil))
            
//                                self.signUpButtonShouldChange(false)
            
                                self.view.endEditing(true)
            
                            } else if let error = error {
            
                                self.showAlert(error)
                            }
                        }
        }

    }

}

// MARK: - UITextFieldDelegate
extension UserProfileVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
// MARK: USER PROFILE PHOTO DELEGATE
extension AccountVC : ProfileDelegate {
    func profile(photo image: UIImage) {
         profileImage = image
    }
}
