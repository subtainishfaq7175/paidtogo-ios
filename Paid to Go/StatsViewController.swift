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

enum Notifications {
    static let DatesUpdated = "notification_user_updated_dates"
}

enum Stats {
    case Incomes
    case SavedGas
    case CarbonOff
}

enum Month : Int {
    case Jan = 0
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dic
}

enum MonthNames : String {
    case Jan = "Jan"
    case Feb = "Feb"
    case Mar = "Mar"
    case Apr = "Apr"
    case May = "May"
    case Jun = "Jun"
    case Jul = "Jul"
    case Aug = "Aug"
    case Sep = "Sep"
    case Oct = "Oct"
    case Nov = "Nov"
    case Dic = "Dic"
}

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
    
    @IBOutlet weak var textFieldFromDate: UITextField!
    
    @IBOutlet weak var lblTotalEarned: UILabel!
    @IBOutlet weak var lblAmountEarned: UILabel!
    
    @IBOutlet weak var incomesChartView: LineChartView!
    @IBOutlet weak var gasChartView: LineChartView!
    @IBOutlet weak var carbonChartview: LineChartView!
    
    // MARK: - Variables and Constants
    
    let kDateFilterSegueIdentifier = "dateFilterSegue"
    
    var lastContentOffset : CGFloat = 0
    var status = Status()
    
    // We use this boolean to verify if the user selected custom dates in DateFilterViewController, and we must reload the stats via API call.
    var shouldReloadStats = false
    
    var newFromDate : NSDate?
    var newToDate : NSDate?
    
    var arrTotalIncomeByMonth = [Double](count: 11, repeatedValue: 0.0)
    var arrTotalSavedGasByMonth = [Double](count: 11, repeatedValue: 0.0)
    var arrTotalCarbonOffByMonth = [Double](count: 11, repeatedValue: 0.0)
    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        
        if shouldReloadStats {
            self.reloadStatsWithCustomDates()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.loadStatsWithDefaultData()
        self.registerForNotifications()
    }
    
    // MARK: - Notifications
    
    private func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationDatesUpdated), name: Notifications.DatesUpdated, object: nil)
    }
    
    @objc private func notificationDatesUpdated(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let fromDate = userInfo["fromDate"] as? NSDate, toDate = userInfo["toDate"] as? NSDate else {
            return
        }
        
        shouldReloadStats = true
        newFromDate = fromDate
        newToDate = toDate
    }
    
    // MARK: - Functions
    
    private func customizeNavigationBar() {
        setNavigationBarVisible(true)
        self.title = "menu_stats".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
        
        let filterImage = UIImage(named: "ic_filter")
        let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: filterImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(btnFilterSelected))
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    private func customizeHeaderView() {
        
        let today = NSDate()
        let todayString = today.toString(DateFormat.Custom("dd/MM/yyyy"))
        self.lblTodate.text = todayString
        
        // Get the date that was 1hr before now
        let todayThreeMonthsBack = NSCalendar.currentCalendar().dateByAddingUnit(
            .Month,
            value: -6,
            toDate: NSDate(),
            options: [])
        let todayThreeMonthsBackString = todayThreeMonthsBack!.toString(DateFormat.Custom("dd/MM/yyyy"))
        self.lblFromdate.text = todayThreeMonthsBackString
    }
    
    // MARK: - Chart Configuration
    
    private func initCharts() {
        loadStatusIncomesData()
        loadStatusSavedGasData()
        loadStatusCarbonOffData()
        
        initChart(incomesChartView, chartDataEntries: arrTotalIncomeByMonth, stats: Stats.Incomes)
        initChart(gasChartView, chartDataEntries: arrTotalSavedGasByMonth, stats: Stats.SavedGas)
        initChart(carbonChartview, chartDataEntries: arrTotalCarbonOffByMonth, stats: Stats.CarbonOff)
    }
    
    private func initChart(chart: LineChartView, chartDataEntries: [Double], stats: Stats) {
        
        chart.userInteractionEnabled = false
        
        let chartData: LineChartData?
        var chartDataSets: [IChartDataSet] = [IChartDataSet]()
        var chartDataSet: ILineChartDataSet = LineChartDataSet()
        var chartEntries: [ChartDataEntry] = [ChartDataEntry]()
        var xVals: [String] = [String]()
        
        // Default: 6 months info
        chartEntries.append(ChartDataEntry(value: chartDataEntries[Month.Feb.rawValue], xIndex: 0))
        chartEntries.append(ChartDataEntry(value: chartDataEntries[Month.Mar.rawValue], xIndex: 1))
        chartEntries.append(ChartDataEntry(value: chartDataEntries[Month.Apr.rawValue], xIndex: 2))
        chartEntries.append(ChartDataEntry(value: chartDataEntries[Month.May.rawValue], xIndex: 3))
        chartEntries.append(ChartDataEntry(value: chartDataEntries[Month.Jun.rawValue], xIndex: 4))
        chartEntries.append(ChartDataEntry(value: chartDataEntries[Month.Jul.rawValue], xIndex: 5))
        
        switch stats {
        case Stats.Incomes:
            chartDataSet = LineChartDataSet(yVals: chartEntries, label: "$")
            break
        case Stats.SavedGas:
            chartDataSet = LineChartDataSet(yVals: chartEntries, label: "Miles Offset")
            break
        default:
            chartDataSet = LineChartDataSet(yVals: chartEntries, label: "CO2 MT’s")
            break
        }
        
        chartDataSet.lineWidth = 3.0
        chartDataSet.fillAlpha = 1.0
        chartDataSets.append(chartDataSet)
        
        xVals.append(MonthNames.Feb.rawValue)
        xVals.append(MonthNames.Mar.rawValue)
        xVals.append(MonthNames.Apr.rawValue)
        xVals.append(MonthNames.May.rawValue)
        xVals.append(MonthNames.Jun.rawValue)
        xVals.append(MonthNames.Jul.rawValue)
        
        chartData = LineChartData(xVals: xVals, dataSets: chartDataSets)
        
        chart.data = chartData
    }
    
    private func loadStatusIncomesData() {
        
        guard let incomes = self.status.incomes as StatusType? else {
            return
        }
        
        for incomeCalculatedUnit in incomes.calculatedUnits! {
            
            guard let dateString = incomeCalculatedUnit.date else {
                continue
            }
            
            let dateStringISO = dateString.substringToIndex(dateString.characters.count-9)
            
            guard let date = dateStringISO.toDate(DateFormat.Custom("yyyy-MM-dd")) else {
                continue
            }
            
            self.arrTotalIncomeByMonth[date.month-1] += incomeCalculatedUnit.value!
        }
    }
    
    private func loadStatusSavedGasData() {
        
        guard let savedGas = self.status.savedGas as StatusType? else {
            return
        }
        
        for savedGasCalculatedUnit in savedGas.calculatedUnits! {

            guard let dateString = savedGasCalculatedUnit.date else {
                continue
            }
            
            let dateStringISO = dateString.substringToIndex(dateString.characters.count-9)
            
            guard let date = dateStringISO.toDate(DateFormat.Custom("yyyy-MM-dd")) else {
                continue
            }
            
            self.arrTotalSavedGasByMonth[date.month-1] += savedGasCalculatedUnit.value!
        }
    }
    
    private func loadStatusCarbonOffData() {
        
        guard let carbonOff = self.status.carbonOff as StatusType? else {
            return
        }
        
        for carbonOffCalculatedUnit in carbonOff.calculatedUnits! {
            
            guard let dateString = carbonOffCalculatedUnit.date else {
                continue
            }
            
            let dateStringISO = dateString.substringToIndex(dateString.characters.count-9)
            
            guard let date = dateStringISO.toDate(DateFormat.Custom("yyyy-MM-dd")) else {
                continue
            }
            
            self.arrTotalCarbonOffByMonth[date.month-1] += carbonOffCalculatedUnit.value!
        }
    }
    
    private func resetDataArrays() {
        
        self.arrTotalIncomeByMonth = [Double](count: self.arrTotalIncomeByMonth.count, repeatedValue: 0.0)
        self.arrTotalSavedGasByMonth = [Double](count: self.arrTotalSavedGasByMonth.count, repeatedValue: 0.0)
        self.arrTotalCarbonOffByMonth = [Double](count: self.arrTotalCarbonOffByMonth.count, repeatedValue: 0.0)
    }
    
    // MARK: - Screen Updates
    
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
    
    private func updateHeaderViewWithNewDates() {
        self.lblFromdate.text = newFromDate?.toString(DateFormat.Custom("dd/MM/yyyy"))
        self.lblTodate.text = newToDate?.toString(DateFormat.Custom("dd/MM/yyyy"))
    }
    
    private func updateFooterViewForIncomes() {
        self.lblTotalEarned.text = "Total Earned"
        guard let balance = self.status.incomes?.balance else {
            return
        }
        self.lblAmountEarned.text = "U$D " + String(format: "%.2f", (balance))
    }
    
    private func updateFooterViewForGas() {
        self.lblTotalEarned.text = "Saved Gas"
        guard let balance = self.status.savedGas?.balance else {
            return
        }
        self.lblAmountEarned.text = "GAL " + String(format: "%.2f", (balance))
    }
    
    private func updateFooterViewForCarbon() {
        self.lblTotalEarned.text = "Total Carbon Off"
        guard let balance = self.status.carbonOff?.balance else {
            return
        }
        self.lblAmountEarned.text = String(format: "%.2f", (balance))
    }
    
    // MARK: - API Calls
    
    private func loadStatsWithDefaultData() {
        
        self.showProgressHud("Loading status...")
        DataProvider.sharedInstance.getStatus { (result, error) in
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                self.navigationController?.popViewControllerAnimated(true)
                
            } else {
                self.status = result!
                self.initCharts()
                self.updateFooterViewForIncomes()
                self.customizeHeaderView()
            }
        }
    }
    
    private func reloadStatsWithCustomDates() {
        
        self.showProgressHud("Reloading status...")
        DataProvider.sharedInstance.getStatusWithTimeInterval(newFromDate!, toDate: newToDate!) { (result, error) in
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                
                self.status = result!
                self.resetDataArrays()
                self.initCharts()
                self.updateHeaderViewWithNewDates()
                self.updateFooterViewForIncomes()
                self.shouldReloadStats = false
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func btnFilterSelected() {
        self.performSegueWithIdentifier(kDateFilterSegueIdentifier, sender: nil)
    }
    
    @IBAction func incomesAction(sender: AnyObject) {
        moveIndicatorToLeft()
        updateFooterViewForIncomes()
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    @IBAction func gasAction(sender: AnyObject) {
        moveIndicatorToCenter()
        updateFooterViewForGas()
        self.scrollView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.width, 0), animated: true)
    }
    
    @IBAction func carbonAction(sender: AnyObject) {
        moveIndicatorToRight()
        updateFooterViewForCarbon()
        self.scrollView.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.width * 2, 0), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x;
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
