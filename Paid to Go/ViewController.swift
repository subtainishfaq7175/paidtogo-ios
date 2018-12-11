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
    
    internal let consShared = Constants.consShared
    internal let idConsShared = IdentifierConstants.idConsShared
    internal let colorShared = CustomColors.colorShared
    internal let utilsShared = AppUtils.utilsShared
    
    var progressHUD : MBProgressHUD?
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.title = ""
        //WARNING!! This is villero. (A bypass for the Rainbow Navigation library, this is done to center the title of the next view controller ).
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Status Bar -
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .Default
//    }
    
    // MARK: - Navigation Bar -
    
    func setNavigationBarVisible(visible: Bool) {
        self.navigationController?.setNavigationBarHidden(!visible, animated: true)
    }
    
    func clearNavigationBarcolor() {
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(UIColor.clear)
        }
    }
    
    func setNavigationBarGreen() {
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(CustomColors.NavbarBackground())
        } 
    }
    
    func setNavigationBarGreenWithTitle(title: String) {
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(CustomColors.NavbarBackground())
            navController.navigationBar.topItem?.title = title
        }
    }
    
    func setNavigationBarColor(color: UIColor){
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(color)
        }
    }
    
    func setNavigationBarColorWithTitle(color: UIColor, title: String){
        if let navController = navigationController {
            navController.navigationBar.df_setBackgroundColor(color)
            navController.navigationBar.topItem?.title = title
        }
    }
    
    func customizeNavigationBarWithTitleAndMenu(){
        let menuImage = UIImage(named: "ic_menu")?.withRenderingMode(.alwaysTemplate)
        let menuButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.plain, target: self, action:#selector(MenuContentViewController.homeButtonAction(sender:)) ) //"homeButtonAction:"
        menuButtonItem.tintColor = CustomColors.NavbarTintColor()
        self.navigationItem.leftBarButtonItem = menuButtonItem
        
        
        let titleImage = UIImage(named: "ic_navbar")
        navigationItem.titleView = UIImageView(image: titleImage)
    }
    
    func customizeNavigationBarWithMenu(){
        let menuImage = UIImage(named: "ic_menu")?.withRenderingMode(.alwaysTemplate)
        let menuButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(MenuContentViewController.homeButtonAction(sender:))) //
        menuButtonItem.tintColor = CustomColors.NavbarTintColor()
        self.navigationItem.leftBarButtonItem = menuButtonItem
    }
    
    func customizeNavigationBarWithBack() {
        let menuImage = UIImage(named: "ic_back35x35")?.withRenderingMode(.alwaysTemplate)
        let menuButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction(sender:))) //
        menuButtonItem.tintColor = CustomColors.NavbarTintColor()
        self.navigationItem.leftBarButtonItem = menuButtonItem
    }
    
    @objc func backAction(sender: AnyObject?) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    // MARK: - Custom Alert View -
    
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Paidtogo", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAndDismissOnCompletion(text: String) {
        let alertController = UIAlertController(title: "Paidtogo", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: popViewController))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAndDismissModallyOnCompletion(text: String) {
        let alertController = UIAlertController(title: "Paidtogo", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: dismissViewController))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(text: String, completion: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: "Paidtogo", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: completion))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UI Configuration -
    
    // MARK: - Views
    
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
    
    // MARK: - Pools
    
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
        default:
            // case .Car:
            view.backgroundColor = CustomColors.carColor()
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
        default:
            //case .Car:
            //            self.title = "car_title".localize()
            let titleImage = UIImage(named: "ic_car")
            navigationItem.titleView = UIImageView(image: titleImage)
            
            //            view.backgroundColor = CustomColors.carColor()
            break
        }
        
        do {
            view.backgroundColor = try UIColor(rgba_throws: type.color!)

        }catch{
            
        }
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
        default:
            // case .Car:
            let titleImage = UIImage(named: "ic_car")
            navigationItem.titleView = UIImageView(image: titleImage)
            break
        }
    }
    
    func setPoolBackgroundImage(header:UIImageView, poolType:PoolType) {
        if let backgroundPicture = poolType.backgroundPicture {
            let backgroundPictureURL = URL(string: backgroundPicture)
            
            header.yy_setImage(with: backgroundPictureURL, options: .showNetworkActivity)
        }
    }
    
    // MARK: - Navigation -
    
    func popViewController(alert: UIAlertAction!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissViewController(alert: UIAlertAction!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func logoutAnimated() {
        if let window = self.view.window {
            window.rootViewController = StoryboardRouter.loginViewController()
        }
    }
    
    func presentHomeViewController() {
        showAlert(text: "switchedToManualTracking".localize()) { (action) in
             self.view.window?.rootViewController? = StoryboardRouter.menuMainViewController()
        }
    }
    
    func presentHomeViewControllerWithoutAnimation() {
        self.present(StoryboardRouter.menuMainViewController(), animated: false, completion: nil)
    }
    
    func presentHomeViewControllerWithExpiredSubscriptionAlert() {
        self.present(StoryboardRouter.menuMainViewController(), animated: false, completion: nil)
//        
//        let mainViewController = StoryboardRouter.menuMainViewController() as! MainViewController
//        
//        self.presentViewController(mainViewController, animated: true) {
//            mainViewController.showAlert("Your Pro User Subscription has expired")
//        }
    }
    
    func showPoolViewController(type: PoolTypeEnum, poolType: PoolType, pool: Pool, sender: AnyObject?) {
        if let poolViewController = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "PoolViewController") as? PoolViewController {
                poolViewController.type = type
                poolViewController.poolType = poolType
                poolViewController.pool = pool
//            self.showViewController(poolViewController, sender: sender)
//            self.presentViewController(poolViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(poolViewController, animated: true)
        }
    }
    
    func showPoolViewControllerWithAntiCheatPhoto(type: PoolTypeEnum, poolType: PoolType, pool: Pool, validationPhoto:String, sender: AnyObject?) {
        if let poolViewController = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "PoolViewController") as? PoolViewController {
            poolViewController.type = type
            poolViewController.poolType = poolType
            poolViewController.pool = pool
            poolViewController.validationPhoto = validationPhoto
//            self.showViewController(poolViewController, sender: sender)
//            self.presentViewController(poolViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(poolViewController, animated: true)
        }
    }
    
    // MARK: - Progress Hud -
    
    func showProgressHud() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
    }
    
    func showProgressHud(title: String) {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = title
    }
    
    func showProgressHud(progress: Float) {
        if progressHUD == nil {
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD?.mode = .annularDeterminate
        }

        progressHUD!.progress = progress
    }
    
    func dismissProgressHud() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        progressHUD = nil
    }
    
}

	
