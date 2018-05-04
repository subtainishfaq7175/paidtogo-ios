//
//  WDLeaderboardsViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 15/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class WDLeaderboardsViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtitleLabel: LocalizableLabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leaderboardImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!

    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var leaderboard: LeaderboardsResponse?
    let cellReuseIdentifier = "leaderboardCell"
    
    var poolType: PoolType?
    var activity: Activity?
    var pool: Pool?
    
    // MARK: - Super
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBorderToView(view: subtitleLabel, color: CustomColors.NavbarTintColor().cgColor)
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    // MARK: - Functions
    
    private func getData() {
        self.showProgressHud()
        
        DataProvider.sharedInstance.getLeaderboardsForPool(poolId: self.activity!.poolId!) { (leaderboard, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(text: error)
                return
            }
            
//            if let leaderboard = leaderboard {
//                
//                self.backgroundImageView.yy_setImageWithURL(NSURL(string: (leaderboard.iconPhoto)!), options: .ShowNetworkActivity)
//                self.placeLabel.text = "1st"
//                
//                self.tableView.dataSource = self
//
//                self.leaderboard  = leaderboard
//                self.tableView.reloadData()
//                
//            }
        }
    }
    
    func initViews(){
        
        self.leaderboardImageView.roundWholeView()
        
        self.typeLabel.text = poolType!.name
        self.locationLabel.text = "Location"
        self.detailLabel.text = "This is where the pool's details will be written"
        self.endDateLabel.text =  self.pool!.endDateTime!.characters.split{$0 == " "}.map(String.init)[0]
 
        self.backgroundImageView.yy_setImage(with: URL(string: (poolType!.backgroundPicture)!), options: .showNetworkActivity)
        
    }
    
    func initLayout() {
        setNavigationBarVisible(visible: true)
        self.title = "menu_leaderboards".localize()
        
        setPoolColor(view: backgroundColorView, type: type!)
        clearNavigationBarcolor()
        
    }
    
    // MARK: - Actions
    
}


extension WDLeaderboardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.leaderboard?.leaderboard!.count)!

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! LeaderboardCell
        
        //        let cell = LeaderboardCell.deque(from: tableView)
        
        cell.configure(leaderboard: (self.leaderboard?.leaderboard![indexPath.row])!)
        
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

extension WDLeaderboardsViewController: UITableViewDelegate {
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! PoolCell
    //
    //
    //        tableView.reloadData()
    //
    //    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.085
    }
}


