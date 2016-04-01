//
//  PoolsViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 30/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class PoolsViewController: ViewController, UIScrollViewDelegate {
    // MARK: - Outlets
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var goImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var openPoolsView: UIView!
    @IBOutlet weak var closedPoolsView: UIView!
    
    @IBOutlet weak var closedPoolsLabel: UILabel!
    // MARK: - Variables and Constants
    
    var type: Pools?
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        
        switch type! {
        case .Walk: self.title = "walk_title".localize()
            break
        case .Bike:
            self.title = "bike_title".localize()
            break
        case .Train:
            self.title = "train_title".localize()
            break
        case .Car:
            self.title = "car_title".localize()
            break
        default:
            break
        }
        
        indicatorLeadingConstraint.constant = openPoolsView.frame.origin.x + 8
        indicatorWidthConstraint.constant = openPoolsView.frame.width - 16 - 6

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.scrollView.delegate = self
    }
    
    
    // MARK: - Functions
    
    private func initViews(){
        goImageView.roundWholeView()
    }
    
    private func moveIndicatorToRight(){
        indicatorLeadingConstraint.constant = closedPoolsView.frame.origin.x + 15
        indicatorWidthConstraint.constant = closedPoolsView.frame.width - 16 - 8
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    private func moveIndicatorToLeft(){
        indicatorLeadingConstraint.constant = openPoolsView.frame.origin.x + 8
        indicatorWidthConstraint.constant = openPoolsView.frame.width - 16 - 6
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
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
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let currentPage = scrollView.currentPage
            print("scrollViewDidEndDragging: \(currentPage)")
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = scrollView.currentPage
//                print("scrollViewDidEndDecelerating: \(currentPage)")
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
    }
    
}

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)+1
    }
    
    func changeToPage(page: Int) {
        self.setContentOffset(CGPointMake(CGFloat(page) * self.frame.width, 0), animated: true)
    }
}
