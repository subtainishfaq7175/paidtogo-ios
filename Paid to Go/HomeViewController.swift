//
//  HomeViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class HomeViewController: MenuContentViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var elautlet: UILabel! // title label
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        customizeNavigationBarWithTitleAndMenu()
        setBorderToView(elautlet, color: CustomColors.NavbarTintColor().CGColor)
    }
    
    // MARK: - Functions
    

    
    // MARK: - Actions
    
    func homeButtonAction(sender: AnyObject?) {
        menuController?.presentMenuViewController()
    }
}