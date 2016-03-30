//
//  HomeViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

enum Pools {
    case Walk
    case Bike
    case Train
    case Car
}

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! PoolsViewController
        
        switch segue.identifier! {
        case "walkSegue":
            destinationViewController.type = .Walk
            break
        case "bikeSegue":
            destinationViewController.type = .Bike
            break
        case "trainSegue":
            destinationViewController.type = .Train
            break
        case "carSegue":
            destinationViewController.type = .Car
            break
        default: break
        }
        
    }
    
    // MARK: - Functions
    
    
    
    // MARK: - Actions
    
    
}