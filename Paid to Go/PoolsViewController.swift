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
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var goImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables and Constants
    
    var type: Pools?
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        
        switch type! {
        case .Walk: self.title = "Walk/Run"
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
        goImageView.roundWholeView()
    }
    
    // MARK: - Actions
    
    @IBAction func openPoolsAction(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    @IBAction func closedPoolsAction(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.width, 0), animated: true)
    }
    
}
