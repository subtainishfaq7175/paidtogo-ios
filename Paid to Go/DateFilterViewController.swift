//
//  DateFilterViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 5/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import SwiftDate

class DateFilterViewController: ViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textFieldToDate: UITextField!
    
    @IBOutlet weak var btnAcceptContainer: UIView!
    
    // MARK: - Variables and constants
    
    var datePickerView : CustomDatePickerView?
    
    var shouldReloadStats = false
    var newFromDate : NSDate?
    var newToDate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    // MARK: Configuration
    
    func configureViews() {
        btnAcceptContainer.round()
        
        self.datePickerView = CustomDatePickerView.instanceFromNib()
        self.datePickerView?.delegate = self
        self.textFieldFromDate.inputView = self.datePickerView
        self.textFieldToDate.inputView = self.datePickerView
    }
    
    // MARK: Navigation
    
    func endEditingBeforeDismisingView( completion: () -> () ) {
        self.view.endEditing(true)
        completion()
    }
    
    // MARK: - IBActions
    
    @IBAction func btnAcceptPressed(sender: AnyObject) {
        
//        guard let fromDate = self.newFromDate, toDate = self.newToDate else {
//            self.showAlert("Please complete all fields")
//            return
//        }
        
        // Dates updated. StatsViewController must reload the stats
//        let userInfo : Dictionary<String,NSDate>! = [
//            "fromDate" : fromDate,
//            "toDate"   : toDate
//        ]
//        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DatesUpdated, object: nil, userInfo: userInfo)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnClosePressed(sender: AnyObject) {
        
        endEditingBeforeDismisingView {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension DateFilterViewController : CustomDatePickerViewDelegate {
    
    func userDidPressBtnCancel() {
        if self.textFieldFromDate.isFirstResponder() {
            self.textFieldFromDate.resignFirstResponder()
        } else {
            self.textFieldToDate.resignFirstResponder()
        }
    }
    
    func userDidPressBtnFilter(selectedDate : NSDate?) {
        if self.textFieldFromDate.isFirstResponder() {
            // Load From Date
            guard let newFromDate = selectedDate else {
                return
            }
            
            self.newFromDate = selectedDate
            
            let newDateString = newFromDate.toString(DateFormat.Custom("dd/MM/yyyy"))
            
            self.textFieldFromDate.text = newDateString
            self.textFieldFromDate.resignFirstResponder()
            
        } else {
            // Load To Date
            guard let newToDate = selectedDate else {
                return
            }
            
            self.newToDate = selectedDate
            
            let newDateString = newToDate.toString(DateFormat.Custom("dd/MM/yyyy"))
            
            self.textFieldToDate.text = newDateString
            self.textFieldToDate.resignFirstResponder()
            
            self.textFieldToDate.resignFirstResponder()
        }
    }
}