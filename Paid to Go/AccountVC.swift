//
//  AccountVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 14/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
// user profile data connections
    @IBOutlet weak var userFirstNameTF: UITextField!
    @IBOutlet weak var userLastNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
//    payment method connections
    @IBOutlet weak var addAccountView: GenCustomView!
//    change password connections
    @IBOutlet weak var changePasswordLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
//        add tap gesture recognizer for add account and change password
        addAccountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelTap(_:))))
        changePasswordLB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelTap(_:))))
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
    

}
