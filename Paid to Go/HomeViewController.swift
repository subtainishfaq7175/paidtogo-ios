//
//  HomeViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class HomeViewController: MenuContentViewController {
    
    // MARK: - Super
    @IBOutlet weak var elautlet: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        customizeNavigationBar()
        
        elautlet.round()
        elautlet.layer.borderWidth = 1.2
        elautlet.layer.borderColor = CustomColors.NavbarTintColor().CGColor
        
    }
    
    // MARK: - Functions
    
    private func customizeNavigationBar(){
        let menuImage = UIImage(named: "ic_menu")?.imageWithRenderingMode(.AlwaysTemplate)
        let menuButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.Plain, target: self, action: "homeButtonAction:")
        menuButtonItem.tintColor = CustomColors.NavbarTintColor()
        self.navigationItem.leftBarButtonItem = menuButtonItem

        
        let titleImage = UIImage(named: "ic_navbar")
        navigationItem.titleView = UIImageView(image: titleImage)
    }
    
    // MARK: - Actions
    
     func homeButtonAction(sender: AnyObject?) {
        menuController?.presentMenuViewController()
    }
}