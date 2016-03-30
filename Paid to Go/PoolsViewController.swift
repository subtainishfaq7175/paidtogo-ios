//
//  PoolsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 30/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class PoolsViewController: ViewController {
    // MARK: - Outlets
    
    
    // MARK: - Variables and Constants
    
    var type: Pools?
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        
        switch type! {
        case .Walk: self.title = "Walk"
            break
        case .Bike:
            self.title = "Bike"
            break
        case .Train:
            self.title = "Bus/Train"
            break
        case .Car:
            self.title = "Car Pool"
            break
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    // MARK: - Functions
    
    func initViews(){
        
    }
    
    // MARK: - Actions
    
    
}
