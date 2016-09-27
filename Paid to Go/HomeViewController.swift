//
//  HomeViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit



class HomeViewController: MenuContentViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var elautlet: UILabel! // title label
    
    // MARK: - View life cycle -
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        
        setBorderToView(elautlet, color: CustomColors.NavbarTintColor().CGColor)
        
        GeolocationManager.initLocationManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeNavigationBarWithTitleAndMenu()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showAlert("Llegue al home")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! PoolsViewController
        
        switch segue.identifier! {
        case "walkSegue":
            
            DataProvider.sharedInstance.getPoolType(.Walk, completion: { (poolType, error) in
                destinationViewController.poolType = poolType
            })
            
            //            destinationViewController.type = .Walk
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
    
    func proUserSubscriptionExpired(notification:NSNotification) {
        
    }
    
    // MARK: - Actions
    
    @IBAction func showPoolsViewController(sender: AnyObject) {
        
        self.showProgressHud()
        
        if let button = sender as? UIButton {
            
            let destinationViewController =
                StoryboardRouter.homeStoryboard().instantiateViewControllerWithIdentifier("PoolsViewController") as! PoolsViewController
            
            switch button.restorationIdentifier! {
            case "button_walk":
                DataProvider.sharedInstance.getPoolType(.Walk, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Walk
                    
                    self.showViewController(destinationViewController, sender: sender)
                    
                })
                break
            case "button_bike":
                DataProvider.sharedInstance.getPoolType(.Bike, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Bike
                    
                    self.showViewController(destinationViewController, sender: sender)
                    
                })

                break
            case "button_train":
                DataProvider.sharedInstance.getPoolType(.Train, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Train
                    
                    self.showViewController(destinationViewController, sender: sender)
                    
                })

                break
            case "button_car":
                DataProvider.sharedInstance.getPoolType(.Car, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Car
                    
                    self.showViewController(destinationViewController, sender: sender)
                    
                })

                break
                
            default: break
                
            }
            
        }
    }
    
}