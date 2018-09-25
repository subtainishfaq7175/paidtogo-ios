//
//  HomeViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 17/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import HealthKitUI
import FSPagerView

class HomeViewController: MenuContentViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var elautlet: UILabel! // title label
    
    @IBOutlet weak var startActivityButton: UIButton!
    @IBOutlet weak var startActivityButtonView: UIView!
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .right
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .selected)
            self.pageControl.setFillColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        }
    }
    
    let geolocationManager =  GeolocationManager.sharedInstance
    var tabsAddedCount = Constants.consShared.ZERO_INT
    var pools = [Pool]()
    var selectedIndex: Int?
    var dateRange = DateRange.today
    var isFirstLaunch = true
    
    static var steps:Double? = Constants.consShared.ZERO_INT.toDouble
    static var mileTravel:Double? = Constants.consShared.ZERO_INT.toDouble
    
    var syncBarButton : UIBarButtonItem?
    
    // MARK: - View life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(visible: true)
        addSyncButton()
        geolocationManager.initLocationManager()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            print("\(self.geolocationManager.getCurrentLocationCoordinate().latitude), \(self.geolocationManager.getCurrentLocationCoordinate().longitude)")
        }
        
        // Enabling all option by deafult
        Settings.shared.enableAllOptionsBydefault()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHealtStore()
        configureViews()
        
        //        getActivityData()
        customizeNavigationBarWithTitleAndMenu()
        NotificationCenter.default.addObserver(self, selector:#selector(proUserSubscriptionExpired(notification:)) , name:.proUserSubscriptionExpired, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(organizationLinked(notification:)) , name:.organizationLinked, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.activitesSynced(notification:)), name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_ACTIVITIES_SYNCED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getActivityData), name: Foundation.Notification.Name(Constants.consShared.NOTIFICATION_WELLDONE_SCREEN_APPEARED), object: nil)
        
        getActivityData()
        
        if let activitydata = ActivityMoniteringManager.sharedManager.activityResponse {
            showWellDone(with: activitydata)
            
        }
    }
    
    func configHealtStore(){
        if PTGHealthStore.healthStoreShared.isHealthDataAvaiable(){
            PTGHealthStore.healthStoreShared.configHealthKit()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showInitailPopUp()
        
        if !ActivityMoniteringManager.sharedManager.isManualActivityDataPresent,
            !Settings.shared.isAutoTrackingOn {
           syncBarButton?.isEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        setBorderToView(view: elautlet, color: CustomColors.NavbarTintColor().cgColor)
    }
    
    func addSyncButton() {
        
        let menuButtonImage = #imageLiteral(resourceName: "ic_sync_p4").withRenderingMode(.alwaysTemplate)
        
        let menuButton = UIBarButtonItem (
            image: menuButtonImage,
            style: .done,
            target: self,
            action: #selector(showSyncAlert(sender:)) // "menuButtonAction:"
        )
        
        menuButton.tintColor = UIColor.black
        menuButton.isEnabled = true
        
        syncBarButton = menuButton
        
        let trackingButtonImage = #imageLiteral(resourceName: "ic_walkrun").withRenderingMode(.alwaysTemplate)
        
        let trackingButton = UIBarButtonItem(
            image: trackingButtonImage,
            style: .done,
            target: self,
            action: #selector(showTracking(sender:)) // "menuButtonAction:"
        )
        
        trackingButton.tintColor = UIColor.black
        trackingButton.isEnabled = true
    
        self.navigationItem.rightBarButtonItems = [menuButton, trackingButton] 
    }
    
    @objc func showSyncAlert(sender: AnyObject?) {
        configHealtStore()
//        showSyncAlert()
        
        ActivityMoniteringManager.sharedManager.postDataAutomatically()
        
        showProgressHud()
        
//        if Settings.shared.isAutoTrackingOn {
//            if let lastSyncDate = Settings.shared.autoTrackingStartDate {
//                let lastDateTimeStamp = lastSyncDate.timeIntervalSince1970
//                let currentTimeStamp = Date().timeIntervalSince1970
//                if currentTimeStamp - lastDateTimeStamp > 86400 {
//                    ActivityMoniteringManager.sharedManager.getHealthKitData()
//                } else {
//                    self.showAlert(text: "Auto activities are synced once a day automaticly, you are sycned for the day.")
//                }
//            }
//
//        } else {
//            if ActivityMoniteringManager.sharedManager.isManualActivityDataPresent {
//                self.showProgressHud()
//                ActivityMoniteringManager.sharedManager.syncManualActivities (completion: { (response, error) in
//                    self.dismissProgressHud()
//                    if error == nil {
//
//                        self.syncBarButton?.isEnabled = false
//                    }
//                })
//            } else {
//                self.showAlert(text: "All Activities are synced.")
//            }
//        }
        
    }
    
    @objc func showTracking(sender: AnyObject?) {
        showTracking()
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
   
    //    MARK: - FETCH DATA FROM SERVER
    
    func getActivityData()  {
        guard let userID = User.currentUser?.userId else {
            return
        }
        self.showProgressHud()
        
        var startDate = Date()
        var endDate = startDate.tomorrow
        
        switch dateRange {
        case .today:
            break
        case .thisWeek:
            startDate = Date().addingTimeInterval(-604800)
            endDate = Date()
            break
        case .thisMonth:
            startDate = Date().addingTimeInterval(-2592000) //startOfMonth
            endDate = Date().endOfMonth
            break
        }
        
        DataProvider.sharedInstance.getSubscribedPools (userID,startDate: startDate, endDate: endDate, completion: { (data, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                
                return
            }
            
            if let data = data {
                self.pools = [Pool]()
                var nationalPool:Pool?
                
                for pool in data {
                    if pool.poolType == .National {
                        nationalPool = pool
                    } else {
                        self.pools.append(pool)
                    }
                }
                
                if let nationalPool = nationalPool {
                    self.pools.insert(nationalPool, at: 0)
                }
                
                Pool.pools = self.pools
                
                // Stop monetering all regions
                GeolocationManager.sharedInstance.stopMoneteringRegions()
                GeolocationManager.sharedInstance.clearSavedLocation()
                
                // add all the items
                for pool in self.pools {
                    for gymlocation in pool.gymLocations! {
                        GeolocationManager.sharedInstance.add(gymlocation: gymlocation)
                    }
                }
            }
            
            self.addTabs()
            
        })

    }
    
    func showSyncAlert()  {
//        let alertNib = Bundle.main.loadNibNamed("PoolSyncAlert", owner: self, options: nil)?.first as! PoolSyncAlert
//        alertNib.pools = self.getPools()
//        alertNib.syncDelegate = self
//        alertNib.showAlert()
    }
    
    func showTracking()  {
        let viewController = StoryboardRouter.activityMoniteringViewController()
        viewController.showBackButton = true
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    func setInt(_ value:Double?, label:UILabel){
        if let value = value {
            label.text = "\(Int(value))"
        }else{
            label.text = "\(consShared.ZERO_INT)"
        }
    }
    
    func populateUI(_ index:Int, mainPool:MainPoolVC)  {
        if let statics = pools[index].statistics {
            setDouble(statics.savedCalories, label: mainPool.calLB)
            setDouble(statics.traffic , label: mainPool.gasLB)
            setDouble(statics.milesTraveled, label: mainPool.traveledLB)
            setDouble(statics.savedCo2, label: mainPool.offsetLB)
            setInt(statics.totalSteps, label: mainPool.stepLB)
            
            if  pools[index].poolRewardType == .cash {
                setDouble(statics.earnedMoney , label: mainPool.numberLB)
                mainPool.pointsLB.text = "USD"
            } else {
                mainPool.numberLB.text = "\(statics.earnedPoints)"
                mainPool.pointsLB.text = "POINTS"
            }
            
        }
        setString(pools[index].name,label:mainPool.poolNameLb)
        mainPool.dateRange = self.dateRange
        
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
            pageControl.numberOfPages = pools.count + 1
            
//            activityData.count - consShared.ONE_INT
            for index in Constants.consShared.ZERO_INT...(pools.count - consShared.ONE_INT){
                let mainPool = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.MAIN_POOL_VC) as! MainPoolVC
                
                mainPool.delegate = self
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
    
        
        if let selectedIndex = selectedIndex {
            mainScrollView.changeToPage(page: selectedIndex)
            pageControl.currentPage = selectedIndex
        }
    }
    
    // MARK: - Navigation
    
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
    
    //MARK: - Activites Synced
    
    @objc private func activitesSynced(notification: NSNotification) {
        DispatchQueue.main.async {
            self.dismissProgressHud()
            
            if let activitydata = ActivityMoniteringManager.sharedManager.activityResponse {
                self.showWellDone(with: activitydata)
            } else if !self.isFirstLaunch {
                self.showAlert(text: "Data is synced")
            }
            
            self.isFirstLaunch = false
        }
    }
    
    func showWellDone(with activityData:ActivityNotification) {
      
        let viewControler = StoryboardRouter.wellDoneViewController()
        viewControler.activityResponse = activityData
        viewControler.activityType = .none
        
        self.navigationController?.pushViewController(viewControler, animated: true)
        
        ActivityMoniteringManager.sharedManager.activityResponse = nil
        
        getActivityData()
    }
    
    // MARK: - Functions
    
    @objc func proUserSubscriptionExpired(notification:NSNotification) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Paidtogo", message:
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
    
    @objc func organizationLinked(notification:NSNotification) {
       getActivityData()
    }
    
    
    func configureViews() {
        configureButtonView()
        mainScrollView.delegate = self
    }
    
    func configureButtonView () {
        startActivityButtonView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        startActivityButtonView.cardView()
        //         startActivityButtonView.layer.cornerRadius = (startActivityButtonView.bounds.height / 2) - 2
    }
    
    func showInitailPopUp() {
        if !Settings.shared.initialPopUpAlreadyShown {
            Settings.shared.initialPopUpAlreadyShown = true
            showAlert(text: "initialPopUpText".localize())
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        showTracking()
    }
    
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

extension HomeViewController :UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedIndex = scrollView.currentPage
        self.pageControl.currentPage = selectedIndex!
    }
}

extension HomeViewController :MainPoolVCDelegate {
    func dateRangeUpdated(withDateRange dateRange: DateRange) {
        self.dateRange = dateRange
        getActivityData()
    }
}
