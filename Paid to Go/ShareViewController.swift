//
//  ShareViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 7/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class ShareViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var finishButtonView: UIView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var shareTextLabel: LocalizableLabel!
    @IBOutlet weak var shareTextLabelBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables and Constants
    
    var type: Pools?
    
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Functions
    
    private func initLayout() {
        setNavigationBarVisible(true)
        //        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        self.title = "share_title".localize()
        setPoolColor(backgroundColorView, type: type!)
        
        
        if DeviceType.IS_IPHONE_4_OR_LESS { // Device is iPhone 4s, 3.5 inches
            shareTextLabel.font = shareTextLabel.font.fontWithSize(12.0)
        }
        if DeviceType.IS_IPHONE_6_OR_GREATER {
//            shareTextLabelBottomConstraint.constant = 36
            shareTextLabel.font = shareTextLabel.font.fontWithSize(16.0)
        }
    }
    
    
    private func initViews() {
        //        goImageView.roundWholeView()
        finishButtonView.round()
    }
    
    
    
    
    // MARK: - Actions
    
    @IBAction func finish(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}
