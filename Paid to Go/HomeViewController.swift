//
//  HomeViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class HomeViewController: MenuContentViewController {
    
    @IBAction func buttonAction(sender: AnyObject) {
        menuController?.presentMenuViewController()
    }
}