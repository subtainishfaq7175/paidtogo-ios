//
//  TermsAndConditionsViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: ViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Terms And Conditions"
       
    }
}
