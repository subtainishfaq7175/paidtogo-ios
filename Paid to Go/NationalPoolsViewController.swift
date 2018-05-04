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
    @IBOutlet weak var tableHeaderView: TableViewHeader!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    @IBOutlet weak var emptyNationalPoolsLabel: UILabel!
    
    // MARK: - Variables and constants
    
    var nationalPools = [Pool]() {
        didSet {
            if nationalPools.count == 0 {
                // No national pools
                DispatchQueue.main.async {
                    self.tableView.isHidden = true
                    self.emptyNationalPoolsLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.emptyNationalPoolsLabel.isHidden = true
                }
            }
        }
    }
    
    var typeEnum : PoolTypeEnum?
    var poolType : PoolType?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPoolColorAndTitle(view: backgroundColorView, typeEnum: typeEnum!, type: poolType!)
        
        self.configureTableView()
        
        self.getNationalPools()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBorderToView(view: headerTitleLabel, color: CustomColors.NavbarTintColor().cgColor)
    }
    
    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let poolDetailVC = segue.destination as! PoolDetailViewController
        if let pool = sender as? Pool {
            poolDetailVC.pool = pool
            poolDetailVC.typeEnum = self.typeEnum
            poolDetailVC.poolType = self.poolType
        }
    }
    
    // MARK: - Methods -
    
    private func initLayout() {
        setNavigationBarVisible(visible: true)
        clearNavigationBarcolor()
        
        headerImageView.yy_setImage(with: URL(string: (poolType?.backgroundPicture)!), options: .showNetworkActivity)
        
        // Configures the table view header -> [ Pool Name - Rate Per Mile ]
        self.tableHeaderView.configureForPools(color: (self.poolType?.color)!)
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - API Calls
    
    func getNationalPools() {
        
        self.showProgressHud()
        
        guard let type = self.typeEnum?.rawValue else {
            return
        }
        
        let poolTypeString = String(type)
        
        DataProvider.sharedInstance.getNationalPools(poolTypeId: poolTypeString) { (pools, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(text: error)
                return
            }
            
            if let pools = pools {
                
                self.nationalPools = pools
                self.tableView.reloadData()
                
            } else {
                self.tableView.isHidden = true
                self.emptyNationalPoolsLabel.isHidden = false
            }
        }

    }
}

extension NationalPoolsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nationalPools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poolCell") as! PoolCell
        cell.configure(pool: nationalPools[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pool = self.nationalPools[indexPath.row]
        self.performSegue(withIdentifier: "poolDetailSegue", sender: pool)
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.085
    }
}


