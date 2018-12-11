//
//  BenefitsOfPaidtogoProViewController.swift
//  Paidtogo
//
//  Created by Razi Tiwana on 04/12/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class BenefitsOfPaidtogoProViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Private Methods
    
    func configureViews() {
        self.title = "benefits_of_pro_title".localize()
        
        for subView in self.view.allSubViewsOf(type: UIView.self) {
            if subView.tag == 10 {
                subView.round()
            }
            
            // UnderLine
            if subView.tag == 11 {
                let button: UIButton = subView as! UIButton
                
                let yourAttributes : [NSAttributedStringKey: Any] = [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
                
                let attributeString = NSMutableAttributedString(string: (button.titleLabel?.text)!,
                                                                attributes: yourAttributes)
                button.setAttributedTitle(attributeString, for: .normal)
            }
        }
        
        
    }

}
