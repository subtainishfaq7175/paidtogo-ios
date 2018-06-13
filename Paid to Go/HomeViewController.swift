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
    var pools = [Pool]()
    static var steps:Double? = Constants.consShared.ZERO_INT.toDouble
    static var mileTravel:Double? = Constants.consShared.ZERO_INT.toDouble

    // MARK: - View life cycle -
    @objc func showSyncAlert(sender: AnyObject?) {
        configHealtStore()
        showSyncAlert()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(visible: true)
        addSyncButton()
       geolocationManager.initLocationManager()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            print("\(self.geolocationManager.getCurrentLocationCoordinate().latitude), \(self.geolocationManager.getCurrentLocationCoordinate().longitude)")
            
        }
    }
    func addSyncButton() {
        
        let menuButtonImage = #imageLiteral(resourceName: "ic_sync_p4").withRenderingMode(.alwaysTemplate)
        
        let menuButton = UIBarButtonItem(
            image: menuButtonImage,
            style: .done,
            target: self,
            action: #selector(showSyncAlert(sender:)) // "menuButtonAction:"
        )
        
        menuButton.tintColor = UIColor.black
        menuButton.isEnabled = true
        
        self.navigationItem.rightBarButtonItem = menuButton
    }

    func getPools() -> [ActivityType] {
        var poolsData = [ActivityType]()
        for pool in pools {
            if let title = pool.name , let id = pool.internalIdentifier {
                poolsData.append(ActivityType(title: title, id: Int(id)!))
            }
        }
        return poolsData
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configHealtStore()
       
        getActivityData()
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
       

    }
    //    MARK: - FETCH DATA FROM SERVER
    
    func getActivityData()  {
        guard let userID = User.currentUser?.userId else {
            return
        }
        self.showProgressHud()
            DataProvider.sharedInstance.getOrganizations(userID, completion: { (data, error) in
//        DataProvider.sharedInstance.getOrganizations("180", completion: { (data, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                
                return
            }
            
            if let data = data {
                self.pools = [Pool]()
                if let sponsorPools = data.sponsorPools {
                    for pool in sponsorPools {
                        self.pools.append(pool)
                    }
                }
                if let nationalPool = data.nationalPool {
                    self.pools.append(nationalPool)
                }
            }
            self.addTabs()
        })
    }
    func showSyncAlert()  {
        let alertNib = Bundle.main.loadNibNamed("PoolSyncAlert", owner: self, options: nil)?.first as! PoolSyncAlert
        alertNib.pools = self.getPools()
        alertNib.syncDelegate = self
        alertNib.showAlert()
    }
    func setString (_ string:String?, label:UILabel){
        if let string = string {
            label.text = string
        }else{
            label.text = consShared.ZERO_INT.toString
        }
    }
    func setDouble (_ value:Double?, label:UILabel){
        if let value = value {
            label.text = "\(value)"
        }else{
            label.text = "\(consShared.ZERO_INT.toDouble)"
        }
    }
    func populateUI(_ index:Int, mainPool:MainPoolVC)  {
        if let statics = pools[index].statistics{
            setDouble(statics.savedCalories, label: mainPool.calLB)
            setDouble(statics.savedGas , label: mainPool.gasLB)
            setDouble(statics.milesTraveled, label: mainPool.traveledLB)
            setDouble(statics.savedCo2, label: mainPool.offsetLB)
            setDouble(statics.totalSteps, label: mainPool.stepLB)
        }
   
//        for index in 0 ... 2 {
//            let activityTable = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.ACTIVITY_TABLE_VC) as! ActivityTableVC
//            createTabVC(activityTable, frame: CGRect(x: mainPool.view.frame.size.width * index.toCGFloat, y: mainPool.activitySV.frame.origin.y, width: mainPool.activitySV.frame.size.width, height: mainPool.activitySV.frame.size.height), scrollView: mainPool.activitySV)
//        }
//        mainPool.activitySV.contentSize = CGSize(width: mainPool.activitySV.frame.width * 3.0, height: mainPool.activitySV.frame.height)
//
//        mainPool.addTabs()
    }
    // MARK: - Tabs Navigation
    func createTabVC(_ vc:UIViewController,frame:CGRect, scrollView :UIScrollView){
        vc.view.frame = frame
        self.addChildViewController(vc);
        mainScrollView.addSubview(vc.view);
        vc.didMove(toParentViewController: self)
    }
    func addTabs(){
        if pools.count > consShared.ZERO_INT {
//            activityData.count - consShared.ONE_INT
            for index in Constants.consShared.ZERO_INT...(pools.count - consShared.ONE_INT){
                let mainPool = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.MAIN_POOL_VC) as! MainPoolVC
                let frame = CGRect(x: view.frame.size.width * index.toCGFloat, y: mainScrollView.frame.origin.y, width: self.view.frame.size.width, height: mainScrollView.frame.size.height)
                mainPool.view.frame = frame
                populateUI(index, mainPool: mainPool)
                createTabVC(mainPool, frame: CGRect(x: view.frame.size.width * index.toCGFloat, y: mainScrollView.frame.origin.y, width: self.view.frame.size.width, height: mainScrollView.frame.size.height), scrollView: self.mainScrollView)
                if let activities = pools[index].activities {
                    mainPool.activities = activities
                }

            }
        }
        
        createTabVC(StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.ADD_ORGANIZATION_VC) as! AddOrganizationVC, frame: CGRect(x: self.view.frame.size.width * pools.count.toCGFloat, y: mainScrollView.frame.origin.y, width: self.view.frame.size.width, height: mainScrollView.frame.size.height), scrollView: self.mainScrollView)
        self.mainScrollView.contentSize = CGSize(width: view.frame.width * (((pools.count) + Constants.consShared.ONE_INT).toCGFloat), height: mainScrollView.frame.size.height)
        
        
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

extension HomeViewController : SyncDelegate {
    func activity(synced: Bool) {
        if synced {
            getActivityData()
        }else{
            showAlert(text: "There is some network problem.")
        }
    }
}
