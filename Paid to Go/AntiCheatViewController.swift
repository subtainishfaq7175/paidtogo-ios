//
//  AntiCheatViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 18/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class AntiCheatViewController: ViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initLayout()
    }
    
    // MARK: - Functions
    
    private func initLayout() {
        setNavigationBarVisible(true)
        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
//        clearNavigationBarcolor()
        setPoolTitle(.Train)
    }
    
    // MARK: - Actions
    
    
}
