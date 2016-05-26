//
//  NationalPoolsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 26/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift

class NationalPoolsViewController: ViewController {
    
    var typeEnum : PoolTypeEnum?
    var poolType : PoolType?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setPoolTitle(self.typeEnum!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLoad()
        
        self.setNavigationBarColor(UIColor(rgba: poolType!.color!))
    }
    
}
