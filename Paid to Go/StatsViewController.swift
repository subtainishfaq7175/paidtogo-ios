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

/**
 This enum discriminates between the three different types of time periods that the user can select to filter the charts info
 */
enum TimePeriod {
    case SixMonths
    case ThreeMonths
    case LastWeek
}

private enum StatSelected {
    case Income
    case GasSaved
    case CarbonOffset
}

class StatsViewController: MenuContentViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets -
    
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
    
    @IBOutlet weak var sixMonthsButton: UIButton!
    @IBOutlet weak var threeMonthsButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    
    @IBOutlet weak var incomesChartView: LineChartView!
    @IBOutlet weak var gasChartView: LineChartView!
    @IBOutlet weak var carbonChartview: LineChartView!
    
    // MARK: - Variables and Constants -

//    var chartsHelper : ChartsHelper!
    
    var lastContentOffset : CGFloat = 0
    var status = Status()
    
    var currentDate : NSDate! = NSDate()
    
    var newFromDate : NSDate?
    var newToDate : NSDate?
    
    var arrTotalIncomeByMonth = [Double](repeating: 0.0, count: 12)
//    (count: 12, repeatedValue: 0.0)
    var arrTotalSavedGasByMonth = [Double](repeating: 0.0, count: 12)
    var arrTotalCarbonOffByMonth = [Double](repeating: 0.0, count: 12)
    /*  We use the gregorian calendar logic to store the data by week:
     *
     *  [0 - Sun ; 1 - Mon ; 2 - Tue ; 3 - Wed ; 4 - Thu ; 5 - Fri ; 6 - Sat]
     */
    var arrTotalIncomeByWeek = [Double](repeating: 0.0, count: 7)
    var arrTotalSavedGasByWeek = [Double](repeating: 0.0, count: 7)
    var arrTotalCarbonOffByWeek = [Double](repeating: 0.0, count: 7)
    
    /// By default, we select the six months time period
    private var timePeriod = TimePeriod.SixMonths
    
    /*  We use an array to store the total values, according to the time period selected [6 months, 3 months, 1 week]:
     *
     *  [0 - Amount ; 1 - Gas Saved ; 2 - Carbon Off]
     */
    var totalValuesForTimePeriod : [Double] = [Double](repeating: 0.0, count: 3)
    
    private var statSelected = StatSelected.Income
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        
//        self.chartsHelper = ChartsHelper(incomesChart: incomesChartView, gasChart: gasChartView, carbonChart: carbonChartview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        self.loadStatsWithDefaultData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - UI Configuration -
    
    private func customizeNavigationBar() {
        self.title = "menu_stats".localize()
        
        setNavigationBarVisible(visible: true)
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    // MARK: - Chart Configuration -
    
    private func initCharts() {
        
        status.loadIncomesData(monthlyIncomes: &arrTotalIncomeByMonth, weeklyIncomes: &arrTotalIncomeByWeek, currentDate: currentDate as Date)
        status.loadSavedGas(monthlyGasSaved: &arrTotalSavedGasByMonth, weeklyGasSaved: &arrTotalSavedGasByWeek, currentDate: currentDate as Date)
        status.loadCarbonOffset(monthlyCarbonOffset: &arrTotalCarbonOffByMonth, weeklyCarbonOffset:&arrTotalCarbonOffByWeek, currentDate: currentDate as Date)
        
        configureChartForSixMonthsData()
    }
    
    func configureChartForSixMonthsData() {
        timePeriod = TimePeriod.SixMonths
        
//        chartsHelper.configureChartForMonthsData(incomesChartView, values: arrTotalIncomeByMonth, stats:Stats.Incomes, pastMonths: 5, totalValues: &totalValuesForTimePeriod)
//        chartsHelper.configureChartForMonthsData(gasChartView, values: arrTotalSavedGasByMonth, stats:Stats.SavedGas, pastMonths: 5, totalValues: &totalValuesForTimePeriod)
//        chartsHelper.configureChartForMonthsData(carbonChartview, values: arrTotalCarbonOffByMonth, stats:Stats.CarbonOff, pastMonths: 5, totalValues: &totalValuesForTimePeriod)
        
        updateFooterViewForCurrentStatSelected()
    }
    
    func configureChartForThreeMonthsData() {
        timePeriod = TimePeriod.ThreeMonths

//        chartsHelper.configureChartForMonthsData(incomesChartView, values: arrTotalIncomeByMonth, stats:Stats.Incomes, pastMonths: 2, totalValues: &totalValuesForTimePeriod)
//        chartsHelper.configureChartForMonthsData(gasChartView, values: arrTotalSavedGasByMonth, stats:Stats.SavedGas, pastMonths: 2, totalValues: &totalValuesForTimePeriod)
//        chartsHelper.configureChartForMonthsData(carbonChartview, values: arrTotalCarbonOffByMonth, stats:Stats.CarbonOff, pastMonths: 2, totalValues: &totalValuesForTimePeriod)
        
        updateFooterViewForCurrentStatSelected()
    }
    
    func configureChartForCurrentWeek() {
        timePeriod = TimePeriod.LastWeek

//        chartsHelper.configureChartForWeekData(incomesChartView, values: arrTotalIncomeByWeek, stats: Stats.Incomes, totalValues: &totalValuesForTimePeriod)
//        chartsHelper.configureChartForWeekData(gasChartView, values: arrTotalSavedGasByWeek, stats: Stats.SavedGas, totalValues: &totalValuesForTimePeriod)
//        chartsHelper.configureChartForWeekData(carbonChartview, values: arrTotalCarbonOffByWeek, stats: Stats.CarbonOff, totalValues: &totalValuesForTimePeriod)
        
        updateFooterViewForCurrentStatSelected()
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
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func moveIndicatorToCenter(){
        setIndicatorOnCenter()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func moveIndicatorToLeft(){
        setIndicatorOnLeft()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateFooterViewForCurrentStatSelected() {
        switch statSelected {
        case StatSelected.Income:
            updateFooterViewForIncomes()
            break
        case StatSelected.GasSaved:
            updateFooterViewForGas()
            break
        default:
            updateFooterViewForCarbon()
            break
        }
    }
    
    private func updateFooterViewForIncomes() {
        self.lblTotalEarned.text = "Total Earned"
        self.lblAmountEarned.text = "$ " + String(format: "%.2f", (totalValuesForTimePeriod[0]))
    }
    
    private func updateFooterViewForGas() {
        self.lblTotalEarned.text = "Saved Gas"
        self.lblAmountEarned.text = "$ " + String(format: "%.2f", (totalValuesForTimePeriod[1]))
    }
    
    private func updateFooterViewForCarbon() {
        self.lblTotalEarned.text = "Metric Tons Offset"
        self.lblAmountEarned.text = "$ " + String(format: "%.2f", (totalValuesForTimePeriod[2]))
    }
    
    // MARK: - API Calls
    
    private func loadStatsWithDefaultData() {
        
        self.showProgressHud(title: "Loading status...")
        DataProvider.sharedInstance.getStatus { (result, error) in
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(text: error)
                self.navigationController?.popViewController(animated: true)
                
            } else {
                self.status = result!
                self.initCharts()
                self.updateFooterViewForIncomes()
            }
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func sixMonthsButtonAction(sender: AnyObject) {
        
        configureChartForSixMonthsData()
        
        sixMonthsButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        threeMonthsButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        thisMonthButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
    
    @IBAction func threeMonthsButtonAction(sender: AnyObject) {
        
        configureChartForThreeMonthsData()
        
        sixMonthsButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        threeMonthsButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        thisMonthButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
    
    @IBAction func thisMonthButtonAction(sender: AnyObject) {
        
        configureChartForCurrentWeek()
        
        sixMonthsButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        threeMonthsButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        thisMonthButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    @IBAction func incomesAction(sender: AnyObject) {
        statSelected = StatSelected.Income
        print("Selected - Income")
        moveIndicatorToLeft()
        updateFooterViewForIncomes()
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func gasAction(sender: AnyObject) {
        statSelected = StatSelected.GasSaved
        print("Selected - GasSaved")
        moveIndicatorToCenter()
        updateFooterViewForGas()
        self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
    }
    
    @IBAction func carbonAction(sender: AnyObject) {
        statSelected = StatSelected.CarbonOffset
        print("Selected - CarbonOffset")
        moveIndicatorToRight()
        updateFooterViewForCarbon()
        self.scrollView.setContentOffset(CGPoint(x: (UIScreen.main.bounds.width * 2), y: 0), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.lastContentOffset = scrollView.contentOffset.x;
    }
    
    // Handles manual dragging by swiping on the screen
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if (self.lastContentOffset < scrollView.contentOffset.x) {
            // moved right
            let currentPage = scrollView.currentPage
            
            switch currentPage {
            case 1:
                statSelected = StatSelected.Income
                print("Selected - Income")
                moveIndicatorToLeft()
                updateFooterViewForIncomes()
                break
            case 2:
                statSelected = StatSelected.GasSaved
                print("Selected - GasSaved")
                moveIndicatorToCenter()
                updateFooterViewForGas()
                break
            case 3:
                statSelected = StatSelected.CarbonOffset
                print("Selected - CarbonOffset")
                moveIndicatorToRight()
                updateFooterViewForCarbon()
                break
            default:
                break
            }
        } else if (self.lastContentOffset > scrollView.contentOffset.x) {
            // moved left
            let currentPage = scrollView.currentPage
            
            switch currentPage {
            case 1:
                statSelected = StatSelected.Income
                print("Selected - Income")
                moveIndicatorToLeft()
                updateFooterViewForIncomes()
                break
            case 2:
                statSelected = StatSelected.GasSaved
                print("Selected - GasSaved")
                moveIndicatorToCenter()
                updateFooterViewForGas()
                break
            case 3:
                statSelected = StatSelected.CarbonOffset
                print("Selected - CarbonOffset")
                moveIndicatorToRight()
                updateFooterViewForCarbon()
                break
            default:
                break
            }
        } else {
            
        }
    }
    
    // MARK: - Helper methods -
    
    func updateIncomesForDayOfWeek(income:Double, dayOfWeek:Int) {
        self.arrTotalIncomeByWeek[dayOfWeek] += income
    }
    
    func updateSavedGasForDayOfWeek(savedGas:Double, dayOfWeek:Int) {
        self.arrTotalSavedGasByMonth[dayOfWeek] += savedGas
    }
    
    func updateCarbonOffForDayOfWeek(carbonOff:Double, dayOfWeek:Int) {
        self.arrTotalCarbonOffByWeek[dayOfWeek] += carbonOff
    }
    
    func printTotalIncomeByMonth() {
        print("INCOME:")
        
        for index in 0..<12 {
//            print("Month: \(chartsHelper.getMonthName(index))")
            print("Income: \(arrTotalIncomeByMonth[index])")
        }
    }
}
