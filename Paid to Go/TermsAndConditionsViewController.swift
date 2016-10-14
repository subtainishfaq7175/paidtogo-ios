//
//  TermsAndConditionsViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: ViewController {
    
//    @IBOutlet weak var navBarBackgroundView: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var termsAndConditionsText : String?
    var poolType : PoolType?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let poolType = self.poolType else {
            return
        }
    
        if let colorString = poolType.color as String? {
            if let color = UIColor(rgba: colorString) as UIColor? {
                setNavigationBarColor(color)

            }
        }
        
        if let text = self.termsAndConditionsText where !text.isEmpty {
            self.contentLabel.text = text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Terms And Conditions"
        
        let closeImage = UIImage(named: "ic_close")?.imageWithRenderingMode(.AlwaysTemplate)
        let closeButtonItem = UIBarButtonItem(image: closeImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TermsAndConditionsViewController.closeButtonAction(_:)))
        closeButtonItem.tintColor = CustomColors.NavbarTintColor()
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc private func closeButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
