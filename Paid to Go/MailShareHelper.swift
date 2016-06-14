//
//  MailShareHelper.swift
//  Paid to Go
//
//  Created by Nahuel on 14/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class MailShareHelper : UIViewController, MFMailComposeViewControllerDelegate {

    func sendMail() {
        print("SEND MAIL!!!")
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
    }
}
