//
//  CustomDatePickerView.swift
//  Paid to Go
//
//  Created by Nahuel on 4/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

protocol CustomDatePickerViewDelegate {
    func userDidPressBtnCancel()
    func userDidPressBtnFilter()
}

class CustomDatePickerView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: - Variables and constants
    
    var delegate : CustomDatePickerViewDelegate?
    
    static func instanceFromNib() -> CustomDatePickerView {
        return UINib(nibName: "CustomDatePicker", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first! as! CustomDatePickerView
    }

    override func awakeFromNib() {
        
        let btnCloseImage = UIImage(named: "ic_close")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.btnClose.setImage(btnCloseImage, forState: UIControlState.Normal)
        self.btnClose.tintColor = UIColor.init(colorLiteralRed: 234.0, green: 233.0, blue: 229.0, alpha: 1.0)
    }

    @IBAction func btnCancelPressed(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.userDidPressBtnCancel()
        }
    }
    
    @IBAction func btnFilterPressed(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.userDidPressBtnFilter()
        }
    }
}
