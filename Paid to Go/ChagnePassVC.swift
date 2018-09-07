//
//  ChagnePassVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 21/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class ChagnePassVC: BaseVc {

    @IBOutlet weak var oldPasswordTF: HoshiTextField!
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
            present(alert( "Confirm Password field is empty"), animated: true, completion: nil)

            return false
        }
        if oldPasswordTF.text! == "" {
            present(alert( "Old Password field is empty"), animated: true, completion: nil)
            
            return false
        }
        
        if ((passwrodTF.text?.count) ?? 0) < 8 {
            present(alert( "The new password must be at least 8 characters."), animated: true, completion: nil)
            
            return false
        }
        
        if passwrodTF.text == repeatPasswordTF.text {
            return true
        }else {
            present(alert( "New Password and Confirm Password doesn't match."), animated: true, completion: nil)
            return false
        }
    }
    
    func changePassword(){
        if validate() {
            
            self.showProgressHud()
            
            DataProvider.sharedInstance.changePassword(oldPasswordTF.text!, newPassword:passwrodTF.text!) { (message, error) in
                self.dismissProgressHud()
                if error == nil {
                    self.present(self.alert(message!), animated: true, completion: nil)
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
