//
//  HomeViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import HealthKitUI


class HomeViewController: MenuContentViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var elautlet: UILabel! // title label
    let geolocationManager =  GeolocationManager.sharedInstance
    var tabsAddedCount = Constants.consShared.ZERO_INT
    // MARK: - View life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(visible: true)
        
       geolocationManager.initLocationManager()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            print("\(self.geolocationManager.getCurrentLocationCoordinate().latitude), \(self.geolocationManager.getCurrentLocationCoordinate().longitude)")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHealtStore()
        customizeNavigationBarWithTitleAndMenu()
        NotificationCenter.default.addObserver(self, selector:#selector(proUserSubscriptionExpired(notification:)) , name: NSNotification.Name(rawValue: NotificationsHelper.ProUserSubscriptionExpired.rawValue), object: nil)
    }
        func configHealtStore(){
            if PTGHealthStore.healthStoreShared.isHealthDataAvaiable(){
                PTGHealthStore.healthStoreShared.configHealthKit()
            }

        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setBorderToView(view: elautlet, color: CustomColors.NavbarTintColor().cgColor)
        if tabsAddedCount == Constants.consShared.ONE_INT {
            self.addTabs()
        }
        tabsAddedCount += Constants.consShared.ONE_INT

    }
    // MARK: - Tabs Navigation
    func createTabVC(_ vc:UIViewController,frame:CGRect){
        vc.view.frame = frame
        self.addChildViewController(vc);
        self.mainScrollView!.addSubview(vc.view);
        vc.didMove(toParentViewController: self)
    }
    func addTabs(){
        let dataArray:[String] = ["tab"]
        for index in Constants.consShared.ZERO_INT...(dataArray.count - 1){
            createTabVC(StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.MAIN_POOL_VC) as! MainPoolVC, frame: CGRect(x: view.frame.size.width * index.toCGFloat, y: mainScrollView.frame.origin.y, width: self.view.frame.size.width, height: mainScrollView.frame.size.height))
        }
        createTabVC(StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.ADD_ORGANIZATION_VC) as! AddOrganizationVC, frame: CGRect(x: self.view.frame.size.width * dataArray.count.toCGFloat, y: mainScrollView.frame.origin.y, width: self.view.frame.size.width, height: mainScrollView.frame.size.height))
        self.mainScrollView.contentSize = CGSize(width: view.frame.width * ((dataArray.count + Constants.consShared.ONE_INT).toCGFloat), height: mainScrollView.frame.size.height)
        
        
    }
    
    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! PoolsViewController
        switch segue.identifier! {
        case "walkSegue":
            
            DataProvider.sharedInstance.getPoolType(poolTypeEnum: .Walk, completion: { (poolType, error) in
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
    
    @objc func proUserSubscriptionExpired(notification:NSNotification) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Paid to Go", message:
                "Your subscription was cancelled, PRO features will be removed", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: {
                // Update user profile
                
                let userToSend = User()
                userToSend.accessToken = User.currentUser?.accessToken!
                userToSend.type = UserType.Normal.rawValue
                
//                DataProvider.sharedInstance.postUpdateProfile(user: userToSend, completion: { (user, error) in
//                    if let user = user {
//                        User.currentUser = user
//
//                        let notificationName = NotificationsHelper.UserProfileUpdated.rawValue
//                        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notificationName, object: nil))
//                    }
//                })
            })
        }
//        dispatch_async(dispatch_get_main_queue()) {
//
//        }
    }
    
    // MARK: - Actions
    
    @IBAction func showPoolsViewController(sender: AnyObject) {
        
        self.showProgressHud()
        
        if let button = sender as? UIButton {
            
            let destinationViewController =
                StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "PoolsViewController") as! PoolsViewController
            
            switch button.restorationIdentifier! {
            case "button_walk":
                DataProvider.sharedInstance.getPoolType(poolTypeEnum: .Walk, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(text: error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Walk
                    
                    self.show(destinationViewController, sender: sender)
                    
                })
                break
            case "button_bike":
                DataProvider.sharedInstance.getPoolType(poolTypeEnum: .Bike, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(text: error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Bike
                    
                    self.show(destinationViewController, sender: sender)
                    
                })

                break
            case "button_train":
                DataProvider.sharedInstance.getPoolType(poolTypeEnum: .Train, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(text: error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Train
                    
                    self.show(destinationViewController, sender: sender)
                    
                })

                break
            case "button_car":
                DataProvider.sharedInstance.getPoolType(poolTypeEnum: .Car, completion: { (poolType, error) in
                    
                    self.dismissProgressHud()
                    
                    if let error = error {
                        self.showAlert(text: error)
                        return
                    }
                    
                    destinationViewController.poolType = poolType
                    destinationViewController.type = .Car
                    
                    self.show(destinationViewController, sender: sender)
                    
                })

                break
                
            default: break
                
            }
            
        }
    }
    
}

