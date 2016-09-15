//
//  NationalPoolsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 26/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift

class NationalPoolsViewController: ViewController {
    
    // MARK: - IBOutlets -
    
//    @IBOutlet weak var navBarBackgroundView: UIView!    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    @IBOutlet weak var emptyNationalPoolsLabel: UILabel!
    
    // MARK: - Variables and constants
    
    var nationalPools = [Pool]() {
        didSet {
            if nationalPools.count == 0 {
                // No national pools
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.hidden = true
                    self.emptyNationalPoolsLabel.hidden = false
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.hidden = false
                    self.emptyNationalPoolsLabel.hidden = true
                })
            }
        }
    }
    
    var typeEnum : PoolTypeEnum?
    var poolType : PoolType?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPoolColorAndTitle(backgroundColorView, typeEnum: typeEnum!, type: poolType!)
        
        self.configureTableView()
        
        self.getNationalPools()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.setNavigationBarColor(UIColor(rgba: poolType!.color!))
        
//        self.navBarBackgroundView.backgroundColor = UIColor(rgba: poolType!.color!)
    }
    
    // MARK: - Navigation -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let poolDetailVC = segue.destinationViewController as! PoolDetailViewController
        
        if let pool = sender as? Pool {
            poolDetailVC.pool = pool
            poolDetailVC.typeEnum = self.typeEnum
            poolDetailVC.poolType = self.poolType
        }
        
    }
    
    // MARK: - Methods -
    
    private func initLayout() {
        setNavigationBarVisible(true)
        clearNavigationBarcolor()
        
//        self.setNavigationBarColor(UIColor(rgba: poolType!.color!))
        
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        
        headerImageView.yy_setImageWithURL(NSURL(string: (poolType?.backgroundPicture)!), options: .ShowNetworkActivity)
        
//        self.title = "National Pools"
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
    }
    
    // MARK: - API Calls
    
    func getNationalPools() {
        
        self.showProgressHud()
        
        guard let type = self.typeEnum?.rawValue else {
            return
        }
        
        let poolTypeString = String(type)
        
        DataProvider.sharedInstance.getNationalPools(poolTypeString) { (pools, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                return
            }
            
            if let pools = pools {
                
                self.nationalPools = pools
                self.tableView.reloadData()
                
            } else {
                self.tableView.hidden = true
                self.emptyNationalPoolsLabel.hidden = false
            }
        }

    }
}

extension NationalPoolsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nationalPools.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("poolCell") as! PoolCell
        cell.configure(nationalPools[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pool = self.nationalPools[indexPath.row]
        self.performSegueWithIdentifier("poolDetailSegue", sender: pool)
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height * 0.085
    }
}


