//
//  PoolBalanceViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class PoolBalanceViewController: MenuContentViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    var pools = [Pool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
        setupViewController()
        getBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // To tackle a bug that is replacing the title
        title = "Balance"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    private func setupViewController() {
        tableView.estimatedRowHeight = 44.0
    }
    
    func getBalance()  {
        guard let userID = User.currentUser?.userId else {
            return
        }
        self.showProgressHud()
        
        DataProvider.sharedInstance.userBalance(userID, completion: { (data, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                
                return
            }
            
            if let data = data {
                self.pools = [Pool]()
                for pool in data {
                    self.pools.append(pool)
                }
            }
            self.tableView.reloadData()
            
        })
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PoolBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfrows = 0;
        
        switch section {
        case 0:
            numberOfrows = self.pools.count
            break
        case 1:
            numberOfrows =  1
            break
        default:
            break
        }
        
        return numberOfrows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellToReturn: UITableViewCell? = nil
        
        switch indexPath.section {
        case 0:
            let itemCell = tableView.dequeueReusableCell(withIdentifier: BalanceTableViewCell.identifier) as! BalanceTableViewCell
            itemCell.row = indexPath.row
            itemCell.delegate = self
            
            let pool = pools[indexPath.row]
            
            itemCell.poolNameLabel.text = pool.name
            
            var suffex = "USD"
            
            var poolBalanceOrEarnedMoney = pool.balance?.earnedMoney
            
            if pool.poolRewardType == .points {
                poolBalanceOrEarnedMoney = pool.balance?.earnedPoints
                suffex = "POINTS"
            }
            
            if let poolBalance = poolBalanceOrEarnedMoney {
                itemCell.pointsOrEarningLabel.text =  String(format: "$ %.2f %@", poolBalance, suffex)
                if pool.poolRewardType == .points {
                    itemCell.pointsOrEarningLabel.text = "\(poolBalance) " + suffex
                }
            } else {
                itemCell.pointsOrEarningLabel.text = "0 " + suffex
            }
            
            if var sponsorCount = pool.sponsors?.count {
                itemCell.firstSponsorView.isHidden = !(sponsorCount >= 1)
                itemCell.secondSponsorView.isHidden = !(sponsorCount >= 2)
                itemCell.thirdSponsorView.isHidden = !(sponsorCount >= 3)
                
                if sponsorCount > 3 {
                     sponsorCount = 3
                }
                
                itemCell.stackViewHeightConstraint.constant = CGFloat(109 - (109/3 * (3 - sponsorCount)))
                
                if sponsorCount >= 1 {
                    itemCell.firstSopnsorLabel.text = pool.sponsors?[0].title
                }
                
                if sponsorCount >= 2 {
                    itemCell.secondSponsorLabel.text = pool.sponsors?[1].title
                }
                
                if sponsorCount >= 3 {
                    itemCell.thirdSponsorLabel.text = pool.sponsors?[2].title
                }
                
                
            } else {
                // no sponsor
                itemCell.firstSponsorView.isHidden = true
                itemCell.secondSponsorView.isHidden = true
                itemCell.thirdSponsorView.isHidden = true
                
                itemCell.stackViewHeightConstraint.constant = 0
            }
            
            
            
            cellToReturn = itemCell
            break
        case 1:
            let itemCell = tableView.dequeueReusableCell(withIdentifier: AddOrganizationTableViewCell.identifier) as! AddOrganizationTableViewCell
            
            cellToReturn = itemCell
            break
        default:
            break
        }
        
        cellToReturn!.selectionStyle = .none
        
        return cellToReturn!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
    self.navigationController?.pushViewController(StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: idConsShared.LINK_ORGANIZATION_VC) as! LinkOrganizationVC, animated: true)
    
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension PoolBalanceViewController: BalanceTableViewCellDelegate {
    func seeFullHistory(at row: Int) {
        
    }
}

