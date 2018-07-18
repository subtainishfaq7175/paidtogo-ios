//
//  leaderboardViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 13/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import FSPagerView

class LeaderboardViewController: MenuContentViewController {

    // MARK: - Variables
    var itemsCount = 10
    
    // MARK: - Outlets
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
      pageControl.numberOfPages = itemsCount
    }
    
    func setuptableView()  {
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: LeaderboardTableViewCell.identifier) as! LeaderboardTableViewCell
        

        itemCell.selectionStyle = .none
        
        return itemCell
    }
}

extension LeaderboardViewController: FSPagerViewDelegate, FSPagerViewDataSource {
   
    // MARK:- FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return itemsCount
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: LeaderBoardPageViewCell.identifier, at: index) as! LeaderBoardPageViewCell

        return cell
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pageControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
}
