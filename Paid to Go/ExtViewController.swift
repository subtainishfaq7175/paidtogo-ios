//
//  ExtViewController.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 08/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
enum AlertType:Int {
    case simpleMessge,withTask
}
extension UIViewController{
//    this  generate alert for simply showing a message with no action
    func alert(_ message:String, type:AlertType = .simpleMessge, title: String = "Paid to Go", btnTitle:String = "Ok") -> UIAlertController {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        switch type {
        case .simpleMessge:
            alertController.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.default,handler: nil))
            break
        case .withTask:
            break
        }
//         self.present(alertController, animated: true, completion: nil)
        return alertController
    }
}
