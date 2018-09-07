//
//  PoolsViewController.swift
//  Paid to Go
//
//  Created by Germán Campagno on 30/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import CoreLocation

class PoolsViewController: ViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var goImageView: UIImageView!
    @IBOutlet weak var goView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var openPoolsView: UIView!
    @IBOutlet weak var closedPoolsView: UIView!
    
    @IBOutlet weak var openPoolsLabel: UILabel!
    @IBOutlet weak var closedPoolsLabel: UILabel!
    @IBOutlet weak var emptyClosedPoolsLabel: UILabel!
    @IBOutlet weak var emptyOpenPoolsLabel: UILabel!
    
    @IBOutlet weak var openPoolsIndicatorView: UIView!
    @IBOutlet weak var closedPoolsIndicatorView: UIView!
    
    @IBOutlet weak var tableHeaderView: TableViewHeader!
    
    @IBOutlet weak var openPoolsTableView: UITableView!
    @IBOutlet weak var closedPoolsTableView: UITableView!
    
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Attributes
    
    let cellReuseIdentifier = "poolCell"
    let kPoolDetailSegue = "poolDetailSegue"
    
    var type: PoolTypeEnum?
    var poolType: PoolType?
    var closedPools:[Pool] = [Pool]() {
        didSet {
            if closedPools.count == 0 {
                // No closed pools
                DispatchQueue.main.async {
                    self.closedPoolsTableView.isHidden = true
                    self.emptyClosedPoolsLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.closedPoolsTableView.isHidden = false
                    self.emptyClosedPoolsLabel.isHidden = true
                }
            }
        }
    }
    var openPools:[Pool] = [Pool]() {
        didSet {
            if openPools.count == 0 {
                // No open pools
                DispatchQueue.main.async {
                    self.openPoolsTableView.isHidden = true
                    self.emptyOpenPoolsLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.openPoolsTableView.isHidden = false
                    self.emptyOpenPoolsLabel.isHidden = true
                }
            }
        }
    }

    var lastContentOffset : CGFloat = 0
    
    /// If the user switches the pool directly from the pool screen, the view must be updated to match the new pool type selected
    var quickSwitchPool = false
    
    // MARK: - View life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
        
        self.getPools()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        self.openPoolsTableView.delegate = self
        self.openPoolsTableView.dataSource = self
        self.openPoolsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        self.closedPoolsTableView.delegate = self
        self.closedPoolsTableView.dataSource = self
        self.closedPoolsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        setPoolColorAndTitle(view: backgroundColorView, typeEnum: type!, type: poolType!)
//        self.backgroundImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
//        self.getPools()
    }
    
    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "segue_nationalpools" {
            if let destinationVC = segue.destination as? NationalPoolsViewController {
                destinationVC.typeEnum = self.type
                destinationVC.poolType = self.poolType
            }
        }
        
        if segue.identifier == "poolDetailSegue" {
            if let destinationVC = segue.destination as? PoolDetailViewController {
                if let pool = sender as? Pool {
                    destinationVC.pool = pool
                    destinationVC.typeEnum = self.type
                    destinationVC.poolType = self.poolType
                    
                }
            }
        }
    }
  
    
    // MARK: - Functions -
    
    private func showAntiCheatViewController(pool: Pool) {
        let vc = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "AnticheatViewController") as! AntiCheatViewController
        vc.pool = pool
        self.show(vc, sender: nil)
    }
    
    private func initLayout() {
        
        // Sets the indicator [ Open pools - Closed pools ]
        setIndicatorOnLeft()
        
        // Configures the table view header -> [ Pool Name - Rate Per Mile ]
        self.tableHeaderView.configureForPools(color: (self.poolType?.color)!)
        
        // Sets up the view again if the poolType Changed -> [for ex., from Walk/Run to Bike ]
        if quickSwitchPool {
            setPoolColorAndTitle(view: backgroundColorView, typeEnum: type!, type: poolType!)
            quickSwitchPool = false
        }
        
        // Sets the background image according to the pool -> [ Walk - Bike - Bus - Car ]
        setPoolBackgroundImage(header: self.backgroundImageView, poolType: poolType!)
        
        // Sets de National Pools background color
        setPoolColor(view: self.goView, type: type!)
    }
    
    private func initViews() {
        self.goImageView.roundWholeView()
        setBorderToView(view: headerTitleLabel, color: CustomColors.NavbarTintColor().cgColor)
        setPoolBackgroundImage(header: self.backgroundImageView, poolType: poolType!)
    }
    
    private func setIndicatorOnLeft() {
        indicatorLeadingConstraint.isActive = true
        indicatorTrailingConstraint.isActive = false
//        indicatorLeadingConstraint.constant = openPoolsView.frame.origin.x + 8
//        indicatorWidthConstraint.constant = openPoolsView.frame.width - 16
        
        self.closedPoolsLabel.textColor = UIColor.gray
        self.closedPoolsIndicatorView.backgroundColor = UIColor.gray
        
        self.openPoolsLabel.textColor = UIColor.white
        self.openPoolsIndicatorView.backgroundColor = CustomColors.NavbarBackground()
    }
    
    private func setIndicatorOnRight() {
        indicatorLeadingConstraint.isActive = false
        indicatorTrailingConstraint.isActive = true
//        indicatorLeadingConstraint.constant = closedPoolsView.frame.origin.x + 8
//        indicatorWidthConstraint.constant = closedPoolsView.frame.width - 16
        
        self.openPoolsLabel.textColor = UIColor.gray
        self.openPoolsIndicatorView.backgroundColor = UIColor.gray
        
        self.closedPoolsLabel.textColor = UIColor.white
        self.closedPoolsIndicatorView.backgroundColor = CustomColors.lightBlueColor()
    }     
    
    private func moveIndicatorToRight() {
        setIndicatorOnRight()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func moveIndicatorToLeft(){
        setIndicatorOnLeft()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func getPools() {
        
        self.showProgressHud()
        
        guard let type = self.type?.rawValue else {
            return
        }
        
        let poolTypeString = String(type)
        
        DataProvider.sharedInstance.getOpenPools(poolTypeId: poolTypeString) { (pools, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(text: error)
                return
            }
            
            if let pools = pools {
                
                self.openPools  = pools
                self.openPoolsTableView.reloadData()
                
            } else {
                // No open pools
                self.openPoolsTableView.isHidden = true
                self.emptyOpenPoolsLabel.isHidden = false
            }
        }
 
        self.showProgressHud()
        
        DataProvider.sharedInstance.getClosedPools(poolTypeId: poolTypeString) { (pools, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(text: error)
                return
            }
            
            if let pools = pools {
                
                self.closedPools  = pools
                self.closedPoolsTableView.reloadData()
                
            } else {
                // No closed pools
                self.closedPoolsTableView.isHidden = true
                self.emptyClosedPoolsLabel.isHidden = false
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func openPoolsAction(sender: AnyObject) {
        moveIndicatorToLeft()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func closedPoolsAction(sender: AnyObject) {
        moveIndicatorToRight()
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
    }
    
    @IBAction func nationalPoolsAction(sender: AnyObject) {
        
        let destinationVC = StoryboardRouter.nationalPoolsViewController()
        
        destinationVC.typeEnum = self.type
        destinationVC.poolType = self.poolType
        
        self.show(destinationVC, sender: nil)

    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x;
    }
    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if decelerate == false {
//            let currentPage = scrollView.currentPage
//        }
//    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.x) {
            // moved right
            let currentPage = scrollView.currentPage
            print("scrollViewDidEndDragging: \(currentPage)")
            
            switch currentPage {
            case 1:
                moveIndicatorToLeft()
                break
            case 2:
                moveIndicatorToRight()
                break
            default:
                break
            }
        } else if (self.lastContentOffset > scrollView.contentOffset.x) {
            // moved left
            let currentPage = scrollView.currentPage
            print("scrollViewDidEndDragging: \(currentPage)")
            
            switch currentPage {
            case 1:
                moveIndicatorToLeft()
                break
            case 2:
                moveIndicatorToRight()
                break
            default:
                break
            }
        } else {
            
        }
    }
}

// MARK: - UITableViewDataSource and Delegate

extension PoolsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        switch tableView.restorationIdentifier! {
        case "closedPoolsTableView":
            count = closedPools.count
            break
        case "openPoolsTableView":
            count = openPools.count
            break
        default: break
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PoolCell
        
        switch tableView.restorationIdentifier! {
        case "closedPoolsTableView":
            cell.configure(pool: self.closedPools[indexPath.row])
            break
        case "openPoolsTableView":
            cell.configure(pool: self.openPools[indexPath.row])
            break
        default: break
        }
        
        
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor.white
            
        case 1:
            cell.backgroundColor = CustomColors.creamyWhiteColor()
            
            
        default:
            break
        }
        
        return cell
        
    }
}

extension PoolsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == openPoolsTableView {
            let pool = self.openPools[indexPath.row]
            self.performSegue(withIdentifier: kPoolDetailSegue, sender: pool)
        } else {
            let pool = self.closedPools[indexPath.row]
            self.performSegue(withIdentifier: kPoolDetailSegue, sender: pool)
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.085
    }
    
}
