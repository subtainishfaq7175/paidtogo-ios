//
//  ActivityViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: MenuContentViewController, UIScrollViewDelegate {
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var carbonView: UIView!
    @IBOutlet weak var gasView: UIView!
    @IBOutlet weak var incomesView: UIView!
    
    
    @IBOutlet weak var incomesChartView: LineChartView!
    @IBOutlet weak var gasChartView: LineChartView!
    @IBOutlet weak var carbonChartview: LineChartView!
    
    // MARK: - Variables and Constants
    
    var lastContentOffset : CGFloat = 0
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        self.title = "menu_stats".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.initCharts()
    }
    
    // MARK: - Functions
    
    private func initCharts() {
        initChart(incomesChartView)
        
        
    }
    
    private func initChart(chart: LineChartView) {
        
        chart.userInteractionEnabled = false
        
        let incomesData: LineChartData?
        var incomesDataSets: [IChartDataSet] = [IChartDataSet]()
        var incomesDataSet: ILineChartDataSet = LineChartDataSet()
        var incomesEntries: [ChartDataEntry] = [ChartDataEntry]()
        var xVals: [String] = [String]()
        
        incomesEntries.append(ChartDataEntry(value: 10.2, xIndex: 0))
        incomesEntries.append(ChartDataEntry(value: 8.1, xIndex: 1))
        incomesEntries.append(ChartDataEntry(value: 10.6, xIndex: 2))
        incomesEntries.append(ChartDataEntry(value: 9.9, xIndex: 3))
        incomesEntries.append(ChartDataEntry(value: 5.0, xIndex: 4))
        
        incomesDataSet = LineChartDataSet(yVals: incomesEntries, label: "Incomes")
        
        incomesDataSet.lineWidth = 3.0
        incomesDataSet.fillAlpha = 1
    
        
        incomesDataSets.append(incomesDataSet)
        
        
        xVals.append("Jan")
        xVals.append("Feb")
        xVals.append("Mar")
        xVals.append("Apr")
        xVals.append("May")
        
        incomesData = LineChartData(xVals: xVals, dataSets: incomesDataSets)
        
        chart.data = incomesData
        
    }
    
    func initViews(){
    }
    
    private func setIndicatorOnLeft() {
        indicatorLeadingConstraint.constant = incomesView.frame.origin.x + 8
        
    }
    
    private func setIndicatorOnCenter() {
        indicatorLeadingConstraint.constant = gasView.frame.origin.x + 8
        
    }
    
    private func setIndicatorOnRight() {
        indicatorLeadingConstraint.constant = carbonView.frame.origin.x + 8
        
        
    }
    
    private func moveIndicatorToRight() {
        setIndicatorOnRight()
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func moveIndicatorToCenter(){
        setIndicatorOnCenter()
        
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
    
    
    // MARK: - Actions
    
    @IBAction func incomesAction(sender: AnyObject) {
        moveIndicatorToLeft()
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    @IBAction func gasAction(sender: AnyObject) {
        moveIndicatorToCenter()
        self.scrollView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.width, 0), animated: true)
    }
    
    @IBAction func carbonAction(sender: AnyObject) {
        moveIndicatorToRight()
        self.scrollView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.width * 2, 0), animated: true)
    }
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x;
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if decelerate == false {
//        }
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
                moveIndicatorToCenter()
                break
            case 3:
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
                moveIndicatorToCenter()
                break
            case 3:
                moveIndicatorToRight()
                break
            default:
                break
            }
        } else {
            
        }
        
        
    }
    
}

//extension UIScrollView {
//    var currentPage: Int {
//        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)+1
//    }
//
//    func changeToPage(page: Int) {
//        self.setContentOffset(CGPointMake(CGFloat(page) * self.frame.width, 0), animated: true)
//    }
//}
