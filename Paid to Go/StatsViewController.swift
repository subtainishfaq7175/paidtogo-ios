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

//enum Notifications {
//    static let DatesUpdated = "notification_user_updated_dates"
//}

enum Stats {
    case Incomes
    case SavedGas
    case CarbonOff
}

enum GregorianDay : Int {
    case Sun = 0
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
}

enum Day : Int {
    case Mon = 0
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun
}

enum DayNames : String {
    case Mon = "Mon"
    case Tue = "Tue"
    case Wed = "Wed"
    case Thu = "Thu"
    case Fri = "Fri"
    case Sat = "Sat"
    case Sun = "Sun"
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
    
    let kDateFilterSegueIdentifier = "dateFilterSegue"
    
    var lastContentOffset : CGFloat = 0
    var status = Status()
    
    // We use this boolean to verify if the user selected custom dates in DateFilterViewController, and we must reload the stats via API call.
//    var shouldReloadStats = false
    
    var currentDate : NSDate! = NSDate()
    
    var newFromDate : NSDate?
    var newToDate : NSDate?
    
    var arrTotalIncomeByMonth = [Double](count: 12, repeatedValue: 0.0)
    var arrTotalSavedGasByMonth = [Double](count: 12, repeatedValue: 0.0)
    var arrTotalCarbonOffByMonth = [Double](count: 12, repeatedValue: 0.0)
    
    /*  We use the gregorian calendar logic to store the data by week
     [0] -> Sun
     [1] -> Mon
     [2] -> Tue
     [3] -> Wed
     [4] -> Thu
     [5] -> Fri
     [6] -> Sat
     */
    var arrTotalIncomeByWeek = [Double](count: 7, repeatedValue: 0.0)
    var arrTotalSavedGasByWeek = [Double](count: 7, repeatedValue: 0.0)
    var arrTotalCarbonOffByWeek = [Double](count: 7, repeatedValue: 0.0)
    
    // MARK: - View life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        
//        if shouldReloadStats {
//            self.reloadStatsWithCustomDates()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.loadStatsWithDefaultData()
//        self.registerForNotifications()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
//    // MARK: - Notifications -
//    
//    private func registerForNotifications() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationDatesUpdated), name: Notifications.DatesUpdated, object: nil)
//    }
//    
//    @objc private func notificationDatesUpdated(notification:NSNotification) {
//        
//        guard let userInfo = notification.userInfo else {
//            return
//        }
//        
//        guard let fromDate = userInfo["fromDate"] as? NSDate, toDate = userInfo["toDate"] as? NSDate else {
//            return
//        }
//        
//        shouldReloadStats = true
//        newFromDate = fromDate
//        newToDate = toDate
//    }
    
    // MARK: - UI Configuration -
    
    private func customizeNavigationBar() {
        setNavigationBarVisible(true)
        self.title = "menu_stats".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    
    private func customizeHeaderView() {
        
        let today = NSDate()
        let todayString = today.toString(DateFormat.Custom("dd/MM/yyyy"))
        self.lblTodate.text = todayString
        
        // Get the date that was 1hr before now
//        let todayThreeMonthsBack = NSCalendar.currentCalendar().dateByAddingUnit(
//            .Month,
//            value: -5,
//            toDate: today,
//            options: [])
//        let todayThreeMonthsBackString = todayThreeMonthsBack!.toString(DateFormat.Custom("dd/MM/yyyy"))
//        self.lblFromdate.text = todayThreeMonthsBackString
    }
    
    // MARK: - Chart Configuration -
    
    private func initCharts() {
        loadStatusIncomesData()
        loadStatusSavedGasData()
        loadStatusCarbonOffData()
        
        configureChartForSixMonthsData()
    }
    
    private func initChart(chart: LineChartView, chartDataEntries: [Double], stats: Stats, pastMonths: Int) {
        
        chart.userInteractionEnabled = false
        
        let chartData: LineChartData?
        var chartDataSets: [IChartDataSet] = [IChartDataSet]()
//        var chartDataSet: ILineChartDataSet = LineChartDataSet()
        var chartDataSet = LineChartDataSet()
        var chartEntries: [ChartDataEntry] = [ChartDataEntry]()
        var xVals: [String] = [String]()
        var colorsCircle = [NSUIColor]()
        
        // Get current date and previous date
        guard let previousDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Month,
            value: -pastMonths,
            toDate: currentDate,
            options: []) else {
                return
        }
        
        // Get the months between the dates
        let currentMonth = currentDate.month
        let previousMonth = previousDate.month
        
        // For each month, enter the correct data
        var index = 0
        
        for month in previousMonth-1..<currentMonth {
            
            // We get the dataset of the month
            chartEntries.append(ChartDataEntry(value: chartDataEntries[month], xIndex: index))
            index += 1
            
            // We set the correct label for the month
            let monthName = getMonthName(month)
            xVals.append(monthName.rawValue)
            
            // We set a different color to the current month
            var color : UIColor!
            if month == currentMonth-1 {
                color = CustomColors.greenColor()
            } else {
                color = CustomColors.carColor()
            }
            colorsCircle.append(color)
            
        }
        
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
        
        chartDataSet.lineWidth = 2.0
        chartDataSet.fillAlpha = 1.0
        
        // Set font of the labels on top of the circles
        chartDataSet.valueFont = UIFont(name: "OpenSans-Semibold", size: 11.0)!
        // Set colors of the circles
        chartDataSet.circleColors = colorsCircle
        // Set colors for lines, which are displayed on the bottom of the bar, previous to the label $ / Miles Offset / CO2 MT's
//        chartDataSet.colors = colorsCircle
        // Set colors of the labels on top of the circles
        chartDataSet.valueColors = colorsCircle
        // Draws all the colors set above
        chartDataSet.drawValuesEnabled = true
        
        chartDataSets.append(chartDataSet)
        
        chartData = LineChartData(xVals: xVals, dataSets: chartDataSets)
        chart.data = chartData

        // Animates the presentation of the chart
        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    private func initWeekChart(chart: LineChartView, chartDataEntries: [Double], stats: Stats) {
        
        chart.userInteractionEnabled = false
        
        let chartData: LineChartData?
        var chartDataSets: [IChartDataSet] = [IChartDataSet]()
        var chartDataSet = LineChartDataSet()
        var chartEntries: [ChartDataEntry] = [ChartDataEntry]()
        var xVals: [String] = [String]()
        var colorsCircle = [NSUIColor]()
        
        for index in 0..<7 {
            
            // Sunday's income is in the first position of the array, and it's shown in the last position of the chart
            var income = 0.0
            if index == 6 {
                income = chartDataEntries[0]
            } else {
                income = chartDataEntries[index+1]
            }
            
            chartEntries.append(ChartDataEntry(value: income, xIndex: index))
            
            let dayName = getDayName(index)
            xVals.append(dayName.rawValue)
            
            // We set a different color to the current day
            var color : UIColor!
            if index == currentDate.weekday-2 {
                color = CustomColors.greenColor()
            } else {
                color = CustomColors.carColor()
            }
            if index==6 && currentDate.weekday==1 {
                color = CustomColors.greenColor()
            }

            colorsCircle.append(color)
            
        }
        
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
        
        chartDataSet.lineWidth = 2.0
        chartDataSet.fillAlpha = 1.0
        
        // Set font of the labels on top of the circles
        chartDataSet.valueFont = UIFont(name: "OpenSans-Semibold", size: 11.0)!
        // Set colors of the circles
        chartDataSet.circleColors = colorsCircle
        // Set colors for lines, which are displayed on the bottom of the bar, previous to the label $ / Miles Offset / CO2 MT's
//        chartDataSet.colors = colorsCircle
        // Set colors of the labels on top of the circles
        chartDataSet.valueColors = colorsCircle
        // Draws all the colors set above
        chartDataSet.drawValuesEnabled = true
        
        chartDataSets.append(chartDataSet)
        
        chartData = LineChartData(xVals: xVals, dataSets: chartDataSets)
        chart.data = chartData

        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
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
        initChart(incomesChartView, chartDataEntries: arrTotalIncomeByMonth, stats: Stats.Incomes, pastMonths: 5)
        initChart(gasChartView, chartDataEntries: arrTotalSavedGasByMonth, stats: Stats.SavedGas, pastMonths: 5)
        initChart(carbonChartview, chartDataEntries: arrTotalCarbonOffByMonth, stats: Stats.CarbonOff, pastMonths: 5)
    }
    
    func configureChartForThreeMonthsData() {
        initChart(incomesChartView, chartDataEntries: arrTotalIncomeByMonth, stats: Stats.Incomes, pastMonths: 2)
        initChart(gasChartView, chartDataEntries: arrTotalSavedGasByMonth, stats: Stats.SavedGas, pastMonths: 2)
        initChart(carbonChartview, chartDataEntries: arrTotalCarbonOffByMonth, stats: Stats.CarbonOff, pastMonths: 2)
    }
    
    func configureChartForThisMonthsData() {
        initChart(incomesChartView, chartDataEntries: arrTotalIncomeByMonth, stats: Stats.Incomes, pastMonths: 0)
        initChart(gasChartView, chartDataEntries: arrTotalSavedGasByMonth, stats: Stats.SavedGas, pastMonths: 0)
        initChart(carbonChartview, chartDataEntries: arrTotalCarbonOffByMonth, stats: Stats.CarbonOff, pastMonths: 0)
    }
    
    func configureChartForCurrentWeek() {
        initWeekChart(incomesChartView, chartDataEntries: arrTotalIncomeByWeek, stats: Stats.Incomes)
        initWeekChart(gasChartView, chartDataEntries: arrTotalSavedGasByWeek, stats: Stats.SavedGas)
        initWeekChart(carbonChartview, chartDataEntries: arrTotalCarbonOffByWeek, stats: Stats.CarbonOff)
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
    
//    private func reloadStatsWithCustomDates() {
//        
//        self.showProgressHud("Reloading status...")
//        DataProvider.sharedInstance.getStatusWithTimeInterval(newFromDate!, toDate: newToDate!) { (result, error) in
//            self.dismissProgressHud()
//            
//            if let error = error {
//                self.showAlert(error)
//                self.navigationController?.popViewControllerAnimated(true)
//            } else {
//                
//                self.status = result!
//                self.resetDataArrays()
//                self.initCharts()
//                self.updateHeaderViewWithNewDates()
//                self.updateFooterViewForIncomes()
//                self.shouldReloadStats = false
//            }
//        }
//    }
    
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
    
    func getMonthName(month: Int) -> MonthNames {
        
        switch month {
        case Month.Jan.rawValue:
            return MonthNames.Jan
        case Month.Feb.rawValue:
            return MonthNames.Feb
        case Month.Mar.rawValue:
            return MonthNames.Mar
        case Month.Apr.rawValue:
            return MonthNames.Apr
        case Month.May.rawValue:
            return MonthNames.May
        case Month.Jun.rawValue:
            return MonthNames.Jun
        case Month.Jul.rawValue:
            return MonthNames.Jul
        case Month.Aug.rawValue:
            return MonthNames.Aug
        case Month.Sep.rawValue:
            return MonthNames.Sep
        case Month.Oct.rawValue:
            return MonthNames.Oct
        case Month.Nov.rawValue:
            return MonthNames.Nov
        default:
            return MonthNames.Dic
        }
    }
    
    func getDayName(day: Int) -> DayNames {
        
        switch day {
        case Day.Mon.rawValue:
            return DayNames.Mon
        case Day.Tue.rawValue:
            return DayNames.Tue
        case Day.Wed.rawValue:
            return DayNames.Wed
        case Day.Thu.rawValue:
            return DayNames.Thu
        case Day.Fri.rawValue:
            return DayNames.Fri
        case Day.Sat.rawValue:
            return DayNames.Sat
        default:
            return DayNames.Sun
        }
    }
    
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
            print("Month: \(getMonthName(index))")
            print("Income: \(arrTotalIncomeByMonth[index])")
        }
    }
}
