//
//  BaseVc.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 03/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseVc: UIViewController {
    internal let consShared = Constants.consShared
    internal let idConsShared = IdentifierConstants.idConsShared
    internal let colorShared = CustomColors.colorShared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Progress Hud -
    
   internal func showProgressHud() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
    }
    
   internal func showProgressHud(title: String) {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = title
    }
    
  internal  func dismissProgressHud() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
}
