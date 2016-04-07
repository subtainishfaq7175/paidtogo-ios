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
    
    @IBOutlet weak var backgroundColorView: UIView!
    
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
        
    
    }
    
    
    private func initViews() {
//        goImageView.roundWholeView()
    }

    
    
    
    // MARK: - Actions

    
    
}
