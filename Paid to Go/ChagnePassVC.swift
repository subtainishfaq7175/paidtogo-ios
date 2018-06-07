//
//  ChagnePassVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 21/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class ChagnePassVC: BaseVc {

    @IBOutlet weak var passwrodTF: HoshiTextField!
    @IBOutlet weak var repeatPasswordTF: HoshiTextField!
    @IBOutlet weak var changePasswordOL: UIButton!
    @IBAction func changePasswordAction(_ sender: Any) {
        changePassword()
    }
    var checkmarksStruct = CheckmarkStruct()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
    }
    override func viewWillLayoutSubviews() {
        changePasswordOL.layer.cornerRadius = changePasswordOL.frame.size.height / consShared.TWO_INT.toCGFloat
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK: - CHANGE PASSWORD
    private func validate() -> Bool {
        if passwrodTF.text! == "" {
            present(alert( "New Password field is empty"), animated: true, completion: nil)
            
            return false
        }
        if repeatPasswordTF.text! == "" {
            present(alert( "Repeate New Password field is empty"), animated: true, completion: nil)

           
            return false
        }
        if passwrodTF.text == repeatPasswordTF.text{
            return true
        }else {
            present(alert( "New Password and Repeat New password isn't match."), animated: true, completion: nil)
            return false
        }
    }
    func changePassword(){
        if validate() {
            
            self.showProgressHud()
            
            let userToSend: User!
            userToSend = User()
            
            userToSend.accessToken = User.currentUser?.accessToken
            userToSend.password = passwrodTF.text
            
            
            DataProvider.sharedInstance.postUpdateProfile(user: userToSend) { (user, error) in
                
                self.dismissProgressHud()
                
                if let user = user { //success
                    self.present(self.alert("profile_changes_submited".localize()), animated: true, completion: nil)
                  
                    User.currentUser = user
                    self.checkmarksStruct.updateUserLocally()
                } else if let error = error {
                    self.present(self.alert(error), animated: true, completion: nil)
                }
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
extension ChagnePassVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwrodTF {
            repeatPasswordTF.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
        return true
    }
}
