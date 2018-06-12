//
//  PoolSyncAlert.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 12/06/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class PoolSyncAlert: UIView {

    @IBOutlet weak var cancelOL: UIButton!
    @IBOutlet weak var syncOL: UIButton!
    @IBOutlet weak var activePoolLB: UILabel!
    @IBOutlet weak var pollLB: UILabel!
    @IBAction func cancelAction(_ sender: Any) {
        PoolSyncAlert.removeAlert()
    }
    @IBAction func syncAction(_ sender: Any) {
    }
    static let alert = Bundle.main.loadNibNamed("PoolSyncAlert", owner: self, options: nil)?.last as! PoolSyncAlert
    override func awakeFromNib() {
        cancelOL.layer.cornerRadius = cancelOL.frame.height / Constants.consShared.TWO_INT.toCGFloat
        syncOL.layer.cornerRadius = syncOL.frame.height / Constants.consShared.TWO_INT.toCGFloat
    }
   static func showAlert() {
        let windows = UIApplication.shared.windows
        let lastWindow = windows.last
        let bounds = UIScreen.main.bounds
        let frame = CGRect(x: Constants.consShared.EIGHT_INT.toCGFloat , y:  bounds.height / Constants.consShared.THREE_INT.toCGFloat, width: bounds.width - (Constants.consShared.EIGHT_INT * Constants.consShared.TWO_INT).toCGFloat , height: bounds.height / Constants.consShared.THREE_INT.toCGFloat)
        alert.frame = frame
        alert.layer.cornerRadius =  10.0
        lastWindow?.addSubview(alert)
    }
  static func removeAlert() {
        alert.removeFromSuperview()
    }
}
