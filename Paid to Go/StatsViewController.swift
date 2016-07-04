//
//  ActivityViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 23/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class StatsViewController: MenuContentViewController, UIScrollViewDelegate {
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var carbonView: UIView!
    @IBOutlet weak var gasView: UIView!
    @IBOutlet weak var incomesView: UIView!
    
    @IBOutlet weak var lblFromdate: LocalizableLabel!
    @IBOutlet weak var lblTodate: LocalizableLabel!
    
    @IBOutlet weak var lblTotalEarned: UILabel!
    @IBOutlet weak var lblAmountEarned: UILabel!
    
    @IBOutlet weak var incomesChartView: LineChartView!
    @IBOutlet weak var gasChartView: LineChartView!
    @IBOutlet weak var carbonChartview: LineChartView!
    
    // MARK: - Variables and Constants
    
    var lastContentOffset : CGFloat = 0
    var status = Status()
    
//    var dictTotalIncomeByMonth : Dictionary<String,Double> = Dictionary<String,Double>()
    
    var arrTotalIncomeByMonth = [
    
        0.0, // "Jan"
        0.0, // "Feb"
        0.0, // "Mar"
        0.0, // "Apr"
        0.0, // "May"
        0.0, // "Jun"
        0.0, // "Jul"
        0.0, // "Aug"
        0.0, // "Sep"
        0.0, // "Oct"
        0.0, // "Nov"
        0.0, // "Dic"
        
    ]
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        self.title = "menu_stats".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
        customizeHeaderView()
        
        self.showProgressHud("Loading status...")
        DataProvider.sharedInstance.getStatus { (result, error) in
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                
                self.status = result!
                self.initCharts()
                self.updateViewsWithStatus()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
//        self.initCharts()
    }
    
    // MARK: - Functions
    
    private func customizeHeaderView() {
        
        let today = NSDate()
        let todayString = today.toString(DateFormat.Custom("dd/MM/yyyy"))
        self.lblTodate.text = todayString
        
        // Get the date that was 1hr before now
        let todayThreeMonthsBack = NSCalendar.currentCalendar().dateByAddingUnit(
            .Month,
            value: -3,
            toDate: NSDate(),
            options: [])
        let todayThreeMonthsBackString = todayThreeMonthsBack!.toString(DateFormat.Custom("dd/MM/yyyy"))
        self.lblFromdate.text = todayThreeMonthsBackString
    }
    
    private func initCharts() {
        initChart(incomesChartView)
        
        
    }
    
    private func initChart(chart: LineChartView) {
        
        chart.userInteractionEnabled = false
        
        loadStatusData()
        
        let incomesData: LineChartData?
        var incomesDataSets: [IChartDataSet] = [IChartDataSet]()
        var incomesDataSet: ILineChartDataSet = LineChartDataSet()
        var incomesEntries: [ChartDataEntry] = [ChartDataEntry]()
        var xVals: [String] = [String]()
        
        incomesEntries.append(ChartDataEntry(value: self.arrTotalIncomeByMonth[4], xIndex: 0))
        incomesEntries.append(ChartDataEntry(value: self.arrTotalIncomeByMonth[5], xIndex: 1))
        incomesEntries.append(ChartDataEntry(value: self.arrTotalIncomeByMonth[6], xIndex: 2))
        
        incomesDataSet = LineChartDataSet(yVals: incomesEntries, label: "Incomes")
        
        incomesDataSet.lineWidth = 3.0
        incomesDataSet.fillAlpha = 1
        
        incomesDataSets.append(incomesDataSet)
        
        xVals.append("May")
        xVals.append("Jun")
        xVals.append("Jul")
        
        incomesData = LineChartData(xVals: xVals, dataSets: incomesDataSets)
        
        chart.data = incomesData
    }
    
    private func loadStatusData() {
        
        guard let incomes = self.status.incomes as StatusType? else {
            print("NO SE HALLO INCOMES")
            return
        }
        
        for incomeCalculatedUnit in incomes.calculatedUnits! {
            
            if let date = incomeCalculatedUnit.date?.toDate(DateFormat.Custom("yyyy/MM/dd HH:mm:ss")) as NSDate? {
                print("MES: \(date.month)")
                
                self.arrTotalIncomeByMonth[date.month-1] += incomeCalculatedUnit.value!
                
            }
        }
    }
    
    func initViews() {
    
    }
    
    func updateViewsWithStatus() {
        self.lblAmountEarned.text = "U$D " + String(format: "%.2f", (self.status.incomes?.balance)!)
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
