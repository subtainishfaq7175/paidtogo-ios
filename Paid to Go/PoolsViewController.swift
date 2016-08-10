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
    
    // MARK: - Outlets
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var goImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var openPoolsView: UIView!
    @IBOutlet weak var closedPoolsView: UIView!
    
    @IBOutlet weak var openPoolsLabel: UILabel!
    @IBOutlet weak var closedPoolsLabel: UILabel!
    @IBOutlet weak var openPoolsIndicatorView: UIView!
    @IBOutlet weak var closedPoolsIndicatorView: UIView!
    
    @IBOutlet weak var tableHeaderView: TableViewHeader!
    
    @IBOutlet weak var openPoolsTableView: UITableView!
    @IBOutlet weak var closedPoolsTableView: UITableView!
    
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Variables and Constants
    
    let cellReuseIdentifier = "poolCell"
    let kPoolDetailSegue = "poolDetailSegue"
    
    var type: PoolTypeEnum?
    var poolType: PoolType?
    var closedPools:[Pool] = [Pool]()
    var openPools:[Pool] = [Pool]()

    var lastContentOffset : CGFloat = 0
    
    // MARK: - Super
    
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
        setPoolColorAndTitle(backgroundColorView, typeEnum: type!, type: poolType!)
        
        self.backgroundImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
        self.scrollView.delegate = self
        
        self.openPoolsTableView.delegate = self
        self.openPoolsTableView.dataSource = self
        self.openPoolsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        self.closedPoolsTableView.delegate = self
        self.closedPoolsTableView.dataSource = self
        self.closedPoolsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        self.getPools()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "segue_nationalpools" {
            if let destinationVC = segue.destinationViewController as? NationalPoolsViewController {
                destinationVC.typeEnum = self.type
                destinationVC.poolType = self.poolType
            }
        }
        
        if segue.identifier == "poolDetailSegue" {
            if let destinationVC = segue.destinationViewController as? PoolDetailViewController {
                if let pool = sender as? Pool {
                    destinationVC.pool = pool
                    destinationVC.typeEnum = self.type
                    destinationVC.poolType = self.poolType
                }
            }
        }
    }
    
    // MARK: - Functions
    
    private func showAntiCheatViewController(pool: Pool) {
        let vc = StoryboardRouter.homeStoryboard().instantiateViewControllerWithIdentifier("AnticheatViewController") as! AntiCheatViewController
        vc.pool = pool
        self.showViewController(vc, sender: nil)
    }
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
        setIndicatorOnLeft()
        self.tableHeaderView.configureForPools((self.poolType?.color)!)
    }
    
    private func initViews() {
        self.goImageView.roundWholeView()
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        
    }
    
    private func setIndicatorOnLeft() {
        indicatorLeadingConstraint.constant = openPoolsView.frame.origin.x + 8
        indicatorWidthConstraint.constant = openPoolsView.frame.width - 16
        
        self.closedPoolsLabel.textColor = UIColor.grayColor()
        self.closedPoolsIndicatorView.backgroundColor = UIColor.grayColor()
        
        self.openPoolsLabel.textColor = UIColor.whiteColor()
        self.openPoolsIndicatorView.backgroundColor = CustomColors.NavbarBackground()
    }
    
    private func setIndicatorOnRight() {
        indicatorLeadingConstraint.constant = closedPoolsView.frame.origin.x + 8
        indicatorWidthConstraint.constant = closedPoolsView.frame.width - 16
        
        self.openPoolsLabel.textColor = UIColor.grayColor()
        self.openPoolsIndicatorView.backgroundColor = UIColor.grayColor()
        
        self.closedPoolsLabel.textColor = UIColor.whiteColor()
        self.closedPoolsIndicatorView.backgroundColor = CustomColors.lightBlueColor()
    }
    
    private func moveIndicatorToRight() {
        setIndicatorOnRight()
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func moveIndicatorToLeft(){
        setIndicatorOnLeft()
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func getPools() {
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.getOpenPools((poolType?.internalIdentifier)!) { (pools, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                return
            }
            
            
            if let pools = pools {
                
                self.openPools  = pools
                self.openPoolsTableView.reloadData()
                
            }
        }
 
        self.showProgressHud()
        
        DataProvider.sharedInstance.getClosedPools((poolType?.internalIdentifier)!) { (pools, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                return
            }
            
            if let pools = pools {
                
                self.closedPools  = pools
                self.closedPoolsTableView.reloadData()
                
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func openPoolsAction(sender: AnyObject) {
        moveIndicatorToLeft()
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    @IBAction func closedPoolsAction(sender: AnyObject) {
        moveIndicatorToRight()
        scrollView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.width, 0), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x;
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let currentPage = scrollView.currentPage
        }
    }
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! PoolCell
        
        switch tableView.restorationIdentifier! {
        case "closedPoolsTableView":
            cell.configure(self.closedPools[indexPath.row])
            break
        case "openPoolsTableView":
            cell.configure(self.openPools[indexPath.row])
            break
        default: break
        }
        
        
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor.whiteColor()
            
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
            self.performSegueWithIdentifier(kPoolDetailSegue, sender: pool)
        } else {
            let pool = self.closedPools[indexPath.row]
            self.performSegueWithIdentifier(kPoolDetailSegue, sender: pool)
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.085
    }
    
}
