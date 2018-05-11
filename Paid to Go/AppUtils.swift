//
//  AppUtils.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 08/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import MBProgressHUD
class AppUtils {
    static let utilsShared = AppUtils()
    private init(){
        
    }
//    this is generate alert for simply showing a message with no action
    func showAlert(_ vc :UIViewController?, message:String, type:AlertType = .simpleMessge, title: String = "Paid to Go", btnTitle:String = "Ok") {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        switch type {
        case .simpleMessge:
            alertController.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.default,handler: nil))
            break
        case .withTask:
            break
        }
        guard let viewController = vc else {
            return
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Progress Hud -
    
    func showProgressHud(_ vc :UIViewController) {
        let loadingNotification = MBProgressHUD.showAdded(to: vc.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
    }
    
    func showProgressHud(_ vc: UIViewController,title: String) {
        let loadingNotification = MBProgressHUD.showAdded(to: vc.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = title
    }
    
    func dismissProgressHud(_ vc:UIViewController) {
        MBProgressHUD.hideAllHUDs(for: vc.view, animated: true)
    }
    
}
