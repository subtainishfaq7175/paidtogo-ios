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
    func userDidPressBtnFilter(selectedDate: NSDate?)
}

class CustomDatePickerView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Variables and constants
    
    var delegate : CustomDatePickerViewDelegate?
    var selectedDate : NSDate?
    
    static func instanceFromNib() -> CustomDatePickerView {
        return UINib(nibName: "CustomDatePicker", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first! as! CustomDatePickerView
    }

    override func awakeFromNib() {
        
        let btnCloseImage = UIImage(named: "ic_close")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.btnClose.setImage(btnCloseImage, forState: UIControlState.Normal)
        self.btnClose.tintColor = UIColor.init(colorLiteralRed: 234.0, green: 233.0, blue: 229.0, alpha: 1.0)
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        components.year = 0
        let maxDate: NSDate = gregorian.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        self.datePicker.maximumDate = maxDate
    }

    @IBAction func btnCancelPressed(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.userDidPressBtnCancel()
        }
    }
    
    @IBAction func btnFilterPressed(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.userDidPressBtnFilter(self.selectedDate)
        }
    }
    
    @IBAction func datePickerValueChanged(sender: AnyObject) {
        self.selectedDate = self.datePicker.date
    }
    
}
