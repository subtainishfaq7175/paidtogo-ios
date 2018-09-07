//
//  leaderboardViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import FSPagerView

enum LeaderboardTab {
    case activeCommute
    case exercise
}

class LeaderboardViewController: MenuContentViewController {

    // MARK: - Variables
//    var itemsCount = 10
    var pools:[Pool] = [Pool]()
    
    var selectedPool : Pool?
    
    var selectedtab : LeaderboardTab = .activeCommute
    
    // MARK: - Outlets
    
    @IBOutlet weak var activeCommuteButton: UIButton!
    @IBOutlet weak var activeCommuteBottomView: UIView!
    @IBAction func activeCommuteAction(_ sender: Any) {
        selectedButtton(activeCommuteButton)
    }
   
    @IBOutlet weak var excrciseBottomView: UIView!
    @IBOutlet weak var excrciseButton: UIButton!
    @IBAction func excrciseAction(_ sender: Any) {
        selectedButtton(excrciseButton)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(UINib(nibName: "LeaderBoardPageViewCell", bundle: nil), forCellWithReuseIdentifier:LeaderBoardPageViewCell.identifier)
            self.pagerView.itemSize = .zero
            self.pagerView.transformer = FSPagerViewTransformer (type: .linear)
            let transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
            self.pagerView.isInfinite = false
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .right
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .selected)
            self.pageControl.setFillColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
        setupViewController()
        setuptableView()
        updatePageView()
        getLeadeeBoards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    private func setupViewController() {
        title = "Leaderboard"
    }
    
    private func updatePageView() {
      pageControl.numberOfPages = self.pools.count
    }
    
    func setuptableView()  {
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getLeadeeBoards()  {
        guard let userID = User.currentUser?.userId else {
            return
        }
        self.showProgressHud()
        
        DataProvider.sharedInstance.userLeaderBoard(userID, completion: { (data, error) in
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
            
            if self.pools.count > 0 {
                self.selectedPool = self.pools.first
            }
            
            self.tableView.reloadData()
            self.updatePageView()
            self.pagerView.reloadData()
        })
        
    }
    
    //    MARK: - Tab buttons makeup
    
    func selectedButtton(_ button:UIButton)  {
        if button == activeCommuteButton {
            selectedButton(button, bottomView: activeCommuteBottomView)
            unselectedButton(excrciseButton, bottomView: excrciseBottomView)
            self.selectedtab = .activeCommute
            
        } else {
            selectedButton(button, bottomView: excrciseBottomView)
            unselectedButton(activeCommuteButton, bottomView: activeCommuteBottomView)
            self.selectedtab = .exercise
        }
        
        tableView.reloadData()
        pagerView.reloadData()
    }
    
    func selectedButton(_ btn:UIButton, bottomView:UIView)  {
        guard let titleLabel = btn.titleLabel else {
            return
        }
        titleLabel.font = UIFont(name: consShared.OPEN_SANS_SEMIBOLD, size: titleLabel.font.pointSize)
        bottomView.backgroundColor = colorShared.springGreen
        
    }
    func unselectedButton(_ btn:UIButton, bottomView:UIView)  {
        guard let titleLabel = btn.titleLabel else {
            return
        }
        titleLabel.font = UIFont(name: consShared.OPEN_SANS_LIGHT, size: titleLabel.font.pointSize)
        bottomView.backgroundColor = UIColor.white
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedPool = selectedPool {
            if selectedtab  == .activeCommute{
                return (selectedPool.leaderBoard?.activeCommutes?.count)!
            } else {
                return (selectedPool.leaderBoard?.exercices?.count)!
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: LeaderboardTableViewCell.identifier) as! LeaderboardTableViewCell
        
        itemCell.positionSuffixLabel.text = (indexPath.row + 1).ordinal
        itemCell.positionLabel.text = (indexPath.row + 1).toString
        
        var position : LeaderboardPosition?
        
        if selectedtab  == .activeCommute {
            position = selectedPool?.leaderBoard?.activeCommutes![indexPath.row]
        } else {
            position = selectedPool?.leaderBoard?.exercices![indexPath.row]
        }
        
        var fullname: String?
        
        if let firstName = position?.firstName  {
            fullname = firstName
            if let lastName = position?.lastName  {
                fullname = fullname! + " " + lastName
            }
        }
        
        if let milesTraveled = position?.milesTraveled {
            fullname = fullname! + " (\(milesTraveled) miles)"
        }
        
        if let fullname = fullname  {
            itemCell.nameLabel.text = fullname
        }
        
        itemCell.profileImageView.yy_setImage(with: URL(string: (position?.profile_picture)!) , placeholder: UIImage(named: "ic_profile_placeholder"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
            
            guard let img = image else {
                itemCell.profileImageView.image = UIImage(named: "ic_profile_placeholder")
                return
            }
            
            itemCell.profileImageView.image = img
        })
        
        itemCell.selectionStyle = .none
        
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension LeaderboardViewController: FSPagerViewDelegate, FSPagerViewDataSource {
   
    // MARK:- FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.pools.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: LeaderBoardPageViewCell.identifier, at: index) as! LeaderBoardPageViewCell
        
        let pool = pools[index]
        
        cell.poolNameLabel.text = pool.name
        
        cell.positionSuffixLabel.text = (1).ordinal
        cell.positionLabel.text = (1).toString
        
        cell.profileImageView.yy_setImage(with: URL(string: (pool.leaderBoard?.profile_picture ?? "")) , placeholder: UIImage(named: "ic_profile_placeholder"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
            
            guard let img = image else {
                cell.profileImageView.image = UIImage(named: "ic_profile_placeholder")
                return
            }
            
            cell.profileImageView.image = img
        })
        
        var earnedMoney, earnedPoints: Double?
        
        if selectedtab == .activeCommute  {
            earnedMoney = pool.leaderBoard?.firstActiveCommuteEarned_money
            earnedPoints = pool.leaderBoard?.firstActiveCommuteEarned_points
        } else if selectedtab == .exercise  {
            earnedMoney = pool.leaderBoard?.firstExerciceEarned_money
            earnedPoints = pool.leaderBoard?.firstExerciceEarned_points
        }
        
        if let money = earnedMoney, money != 0 {
            cell.pointsLabel.text = money.toString
            cell.pointsOrUSDLabel.text = "USD"
        } else {
            cell.pointsLabel.text = earnedPoints?.toString
            cell.pointsOrUSDLabel.text = "POINTS"
        }
        
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pageControl.currentPage = index
        selectedPool = pools[pagerView.currentIndex]
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        selectedPool = pools[pagerView.currentIndex]
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
        tableView.reloadData()
    }
    
}
