//
//  ViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 16/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//


import UIKit
import RainbowNavigation
import MBProgressHUD
import UIColor_Hex_Swift

class ViewController: UIViewController {
    
    
    // MARK: - Super
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = "" //WARNING!! This is villero. (A bypass for the Rainbow Navigation library, this is done to center the title of the next view controller ).
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    func showAlert(text: String){
        let alertController = UIAlertController(title: "Paid to Go", message:
            text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setNavigationBarVisible(visible: Bool) {
        self.navigationController?.setNavigationBarHidden(!visible, animated: true)
    }
    
    func clearNavigationBarcolor() {
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(UIColor.clearColor())
        }
    }
    
    func setNavigationBarGreen(){
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(CustomColors.NavbarBackground())
        }
    }

    func setNavigationBarColor(color: UIColor){
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(color)
        }
    }

    func setBorderToView(view: UIView, color: CGColor){
        view.round()
        view.layer.borderWidth = 1.2
        view.layer.borderColor = color
    }
    
    func setBorderToViewAndRoundVeryLittle(view: UIView, color: CGColor){
        view.roundVeryLittle()
        view.layer.borderWidth = 1.2
        view.layer.borderColor = color
    }
    
    func customizeNavigationBarWithTitleAndMenu(){
        let menuImage = UIImage(named: "ic_menu")?.imageWithRenderingMode(.AlwaysTemplate)
        let menuButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.Plain, target: self, action: "homeButtonAction:")
        menuButtonItem.tintColor = CustomColors.NavbarTintColor()
        self.navigationItem.leftBarButtonItem = menuButtonItem
        
        
        let titleImage = UIImage(named: "ic_navbar")
        navigationItem.titleView = UIImageView(image: titleImage)
    }
    
    func customizeNavigationBarWithMenu(){
        let menuImage = UIImage(named: "ic_menu")?.imageWithRenderingMode(.AlwaysTemplate)
        let menuButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.Plain, target: self, action: "homeButtonAction:")
        menuButtonItem.tintColor = CustomColors.NavbarTintColor()
        self.navigationItem.leftBarButtonItem = menuButtonItem
        
        
    }
    
    func setPoolColor(view: UIView, type: PoolTypeEnum) {
        switch type {
        case .Walk:
            view.backgroundColor = CustomColors.walkRunColor()
            break
        case .Bike:
            view.backgroundColor = CustomColors.bikeColor()
            break
        case .Train:
            view.backgroundColor = CustomColors.busTrainColor()
            break
        case .Car:
            view.backgroundColor = CustomColors.carColor()
            break
        default:
            break
        }
    }
    
    func setPoolColorAndTitle(view: UIView, typeEnum: PoolTypeEnum, type: PoolType) {
        
        switch typeEnum {
        case .Walk:
            //            self.title = "walk_title".localize()
            let titleImage = UIImage(named: "ic_walkrun")
            navigationItem.titleView = UIImageView(image: titleImage)
            
            
            break
        case .Bike:
            //            self.title = "bike_title".localize()
            let titleImage = UIImage(named: "ic_bike")
            navigationItem.titleView = UIImageView(image: titleImage)
            
            //            view.backgroundColor = CustomColors.bikeColor()
            break
        case .Train:
            //            self.title = "train_title".localize()
            
            let titleImage = UIImage(named: "ic_bustrain")
            navigationItem.titleView = UIImageView(image: titleImage)
            
            //            view.backgroundColor = CustomColors.busTrainColor()
            break
        case .Car:
            //            self.title = "car_title".localize()
            let titleImage = UIImage(named: "ic_car")
            navigationItem.titleView = UIImageView(image: titleImage)
            
            //            view.backgroundColor = CustomColors.carColor()
            break
        default:
            break
        }
        
        view.backgroundColor = UIColor(rgba: type.color!)
        
        
    }
    
    func setPoolTitle(type: PoolTypeEnum) {
        switch type {
        case .Walk:
            let titleImage = UIImage(named: "ic_walkrun")
            navigationItem.titleView = UIImageView(image: titleImage)
            break
        case .Bike:
            let titleImage = UIImage(named: "ic_bike")
            navigationItem.titleView = UIImageView(image: titleImage)
            break
        case .Train:
            let titleImage = UIImage(named: "ic_bustrain")
            navigationItem.titleView = UIImageView(image: titleImage)
            break
        case .Car:
            let titleImage = UIImage(named: "ic_car")
            navigationItem.titleView = UIImageView(image: titleImage)
            break
        default:
            break
        }
    }
    
    func logoutAnimated() {
        if let window = self.view.window {
            window.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func presentHomeViewController() {
        self.presentViewController(StoryboardRouter.menuMainViewController(), animated: true, completion: nil)
    }
    func presentHomeViewControllerWithoutAnimation() {
        self.presentViewController(StoryboardRouter.menuMainViewController(), animated: false, completion: nil)
    }
    
    
    
    func showPoolViewController(type: PoolTypeEnum, poolType: PoolType, pool: Pool, sender: AnyObject?) {
        if let poolViewController = StoryboardRouter.homeStoryboard().instantiateViewControllerWithIdentifier("PoolViewController") as? PoolViewController {
                poolViewController.type = type
                poolViewController.poolType = poolType
                poolViewController.pool = pool
            
                self.showViewController(poolViewController, sender: sender)
        }
    }
    
        
    
        
        func showProgressHud() {
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
        }
        
        func showProgressHud(title: String) {
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = title
        }
        
        func dismissProgressHud() {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        
    }

	