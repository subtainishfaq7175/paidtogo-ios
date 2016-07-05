//
//  DateFilterViewController.swift
//  Paid to Go
//
//  Created by Nahuel on 5/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class DateFilterViewController: ViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textFieldToDate: UITextField!
    
    @IBOutlet weak var btnAcceptContainer: UIView!
    
    // MARK: - Variables and constants
    
    var datePickerView : CustomDatePickerView?
    
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
    
    // MARK: UX / UI
    
    func endEditingBeforeDismisingView( completion: () -> () ) {
        self.view.endEditing(true)
        completion()
    }
    
    // MARK: - IBActions
    
    @IBAction func btnAcceptPressed(sender: AnyObject) {
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
    
    func userDidPressBtnFilter() {
        if self.textFieldFromDate.isFirstResponder() {
            // Load From Date
            
            self.textFieldFromDate.resignFirstResponder()
        } else {
            // Load To Date
            
            self.textFieldToDate.resignFirstResponder()
        }
    }
}