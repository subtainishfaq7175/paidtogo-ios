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

    let chartsHelper = ChartsHelper()
    
    var lastContentOffset : CGFloat = 0
    var status = Status()
    
    var currentDate : NSDate! = NSDate()
    
    var newFromDate : NSDate?
    var newToDate : NSDate?
    
    var arrTotalIncomeByMonth = [Double](count: 12, repeatedValue: 0.0)
    var arrTotalSavedGasByMonth = [Double](count: 12, repeatedValue: 0.0)
    var arrTotalCarbonOffByMonth = [Double](count: 12, repeatedValue: 0.0)
    
    /*  We use the gregorian calendar logic to store the data by week:
     *
     *  [0 - Sun ; 1 - Mon ; 2 - Tue ; 3 - Wed ; 4 - Thu ; 5 - Fri ; 6 - Sat]
     */
    var arrTotalIncomeByWeek = [Double](count: 7, repeatedValue: 0.0)
    var arrTotalSavedGasByWeek = [Double](count: 7, repeatedValue: 0.0)
    var arrTotalCarbonOffByWeek = [Double](count: 7, repeatedValue: 0.0)
    
    // MARK: - View life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
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
        
        setNavigationBarVisible(true)
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    // MARK: - Chart Configuration -
    
    private func initCharts() {
        loadStatusIncomesData()
        loadStatusSavedGasData()
        loadStatusCarbonOffData()
        
        configureChartForSixMonthsData()
    }
    
    // MARK: - Chart Data Source -
    
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
            
            // If the current day is Sunday, we show all the information of the past week
            if currentDate.weekday == 1 {
                if currentDate.weekOfYear-1 == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    self.updateIncomesForDayOfWeek(incomeCalculatedUnit.value!, dayOfWeek: dayOfTheWeek)
                }
                
            } else {
                // If weeks of the year match -> Monday to Saturday
                if currentDate.weekOfYear == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    self.updateIncomesForDayOfWeek(incomeCalculatedUnit.value!, dayOfWeek: dayOfTheWeek)
                }
            }
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
            
            // If the current day is Sunday, we show all the information of the past week
            if currentDate.weekday == 1 {
                if currentDate.weekOfYear-1 == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    self.updateSavedGasForDayOfWeek(savedGasCalculatedUnit.value!, dayOfWeek: dayOfTheWeek)
                }
                
            } else {
                // If weeks of the year match -> Monday to Saturday
                if currentDate.weekOfYear == date.weekOfYear {

                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    self.updateSavedGasForDayOfWeek(savedGasCalculatedUnit.value!, dayOfWeek: dayOfTheWeek)
                }
            }
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
            
            // If the current day is Sunday, we show all the information of the past week
            if currentDate.weekday == 1 {
                if currentDate.weekOfYear-1 == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    self.updateCarbonOffForDayOfWeek(carbonOffCalculatedUnit.value!, dayOfWeek: dayOfTheWeek)
                }
                
            } else {
                // If weeks of the year match -> Monday to Saturday
                if currentDate.weekOfYear == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    self.updateCarbonOffForDayOfWeek(carbonOffCalculatedUnit.value!, dayOfWeek: dayOfTheWeek)
                }
            }
        }
    }
    
    private func resetDataArrays() {
        self.arrTotalIncomeByMonth = [Double](count: self.arrTotalIncomeByMonth.count, repeatedValue: 0.0)
        self.arrTotalSavedGasByMonth = [Double](count: self.arrTotalSavedGasByMonth.count, repeatedValue: 0.0)
        self.arrTotalCarbonOffByMonth = [Double](count: self.arrTotalCarbonOffByMonth.count, repeatedValue: 0.0)
    }
    
    func configureChartForSixMonthsData() {
        
        chartsHelper.configureChartForMonthsData(incomesChartView, values: arrTotalIncomeByMonth, stats:Stats.Incomes, pastMonths: 5)
        chartsHelper.configureChartForMonthsData(gasChartView, values: arrTotalSavedGasByMonth, stats:Stats.SavedGas, pastMonths: 5)
        chartsHelper.configureChartForMonthsData(carbonChartview, values: arrTotalCarbonOffByMonth, stats:Stats.CarbonOff, pastMonths: 5)
    }
    
    func configureChartForThreeMonthsData() {

        chartsHelper.configureChartForMonthsData(incomesChartView, values: arrTotalIncomeByMonth, stats:Stats.Incomes, pastMonths: 2)
        chartsHelper.configureChartForMonthsData(gasChartView, values: arrTotalSavedGasByMonth, stats:Stats.SavedGas, pastMonths: 2)
        chartsHelper.configureChartForMonthsData(carbonChartview, values: arrTotalCarbonOffByMonth, stats:Stats.CarbonOff, pastMonths: 2)
    }
    
    func configureChartForCurrentWeek() {

        chartsHelper.configureChartForWeekData(incomesChartView, values: arrTotalIncomeByWeek, stats: Stats.Incomes)
        chartsHelper.configureChartForWeekData(gasChartView, values: arrTotalSavedGasByWeek, stats: Stats.SavedGas)
        chartsHelper.configureChartForWeekData(carbonChartview, values: arrTotalCarbonOffByWeek, stats: Stats.CarbonOff)
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
            }
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func sixMonthsButtonAction(sender: AnyObject) {
        configureChartForSixMonthsData()
        sixMonthsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        threeMonthsButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        thisMonthButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
    }
    
    @IBAction func threeMonthsButtonAction(sender: AnyObject) {
        configureChartForThreeMonthsData()
        sixMonthsButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        threeMonthsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        thisMonthButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
    }
    
    @IBAction func thisMonthButtonAction(sender: AnyObject) {
        configureChartForCurrentWeek()
        sixMonthsButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        threeMonthsButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        thisMonthButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    }
    
//    @objc private func btnFilterSelected() {
//        self.performSegueWithIdentifier(kDateFilterSegueIdentifier, sender: nil)
//    }
    
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
    
    // Handles manual dragging by swiping on the screen
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.x) {
            // moved right
            let currentPage = scrollView.currentPage
            
            switch currentPage {
            case 1:
                moveIndicatorToLeft()
                updateFooterViewForIncomes()
                break
            case 2:
                moveIndicatorToCenter()
                updateFooterViewForGas()
                break
            case 3:
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
                moveIndicatorToLeft()
                updateFooterViewForIncomes()
                break
            case 2:
                moveIndicatorToCenter()
                updateFooterViewForGas()
                break
            case 3:
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
            print("Month: \(chartsHelper.getMonthName(index))")
            print("Income: \(arrTotalIncomeByMonth[index])")
        }
    }
}
