//
//  WellDoneViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 4/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class WellDoneViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    // MARK: - Variables and Constants
    
    var type: Pools?
        
    // MARK: -  Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Functions
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
        self.title = "menu_home".localize()
        
        switch type! {
        case .Walk:
        backgroundColorView.backgroundColor = CustomColors.walkRunColor()
            break
        case .Bike:
            backgroundColorView.backgroundColor = CustomColors.bikeColor()
            break
        case .Train:
            backgroundColorView.backgroundColor = CustomColors.busTrainColor()
            break
        case .Car:
            backgroundColorView.backgroundColor = CustomColors.carColor()
            break
        default:
            break
        }
        
    }

    
    private func initViews() {
    }
    
    // MARK: - Actions
    
    
    @IBAction func backToHome(sender: AnyObject) {
        self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)

    }
    
}