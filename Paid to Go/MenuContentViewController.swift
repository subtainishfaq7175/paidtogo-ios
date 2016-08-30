//
//  MenuContentViewController.swift
//  Care4
//
//  Created by Fernando Ortiz on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

/**
 All view controllers that are selected as content view controller should have, for example,
 the menu button in the navigation bar.
 
 In this class, the menu button. Other things are done too.
 */
class MenuContentViewController: ViewController {
    
    weak var menuButton: UIButton?
    var menuController: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMenuButton()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        clearNavigationBarcolor()
    }
    
    func addMenuButton() {
        
        let menuButtonImage = UIImage(named: "ic_add_green")?.imageWithRenderingMode(.AlwaysTemplate)
        
        let menuButton = UIBarButtonItem(
            image: menuButtonImage,
            style: .Done,
            target: self,
            action: #selector(MenuContentViewController.homeButtonAction(_:)) // "menuButtonAction:"
        )
        
        menuButton.tintColor = UIColor.whiteColor()
        menuButton.enabled = true
        
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func homeButtonAction(sender: AnyObject?) {
        menuController?.presentMenuViewController()
    }
}
