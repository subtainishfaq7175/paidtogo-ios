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
    internal let consShared = Constants.consShared
    internal let idConsShared = IdentifierConstants.idConsShared
    internal let colorShared = CustomColors.colorShared
    internal let utilsShared = AppUtils.utilsShared
    weak var menuButton: UIButton?
    var menuController: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMenuButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearNavigationBarcolor()
    }
    
    func addMenuButton() {
        
        let menuButtonImage = UIImage(named: "ic_add_green")?.withRenderingMode(.alwaysTemplate)
        
        let menuButton = UIBarButtonItem(
            image: menuButtonImage,
            style: .done,
            target: self,
            action: #selector(MenuContentViewController.homeButtonAction(sender:)) // "menuButtonAction:"
        )
        
        menuButton.tintColor = UIColor.white
        menuButton.isEnabled = true
        
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func homeButtonAction(sender: AnyObject?) {
        menuController?.presentMenuViewController()
    }
}
