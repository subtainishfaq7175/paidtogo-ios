//
//  ChartsHelper.swift
//  Paid to Go
//
//  Created by Nahuel on 14/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import Charts

// MARK: - Enums -

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

/// Handles the configuration of the charts presented in the StatsViewController
class ChartsHelper: NSObject {
    
    var chartData = LineChartData()
    var lineChartDataSet = LineChartDataSet()
    
    var chartDataEntries = [IChartDataSet]()
    var chartDataSetEntries = [ChartDataEntry]()
    
    var xVals: [String] = [String]()
    
    var colorsCircle = [NSUIColor]()
    var colorsLabel = [NSUIColor]()
    
    var currentDate : NSDate! = NSDate()
    var previousDate : NSDate! = NSDate()
    
    /**
     Adds the value for the corresponding date
     
     - parameter value: ammount (earnings, gas saved, carbon offset)
     - parameter index: date (month or day)
     */
    func addYValueForXDate(value:Double, index:Int) {
        let chartDataSetEntry = ChartDataEntry(value: value, xIndex: index)
        chartDataSetEntries.append(chartDataSetEntry)
    }
    
    func addXDate(date:String) {
        xVals.append(date)
    }
    
    func configureChartForMonthsData(lineChart:LineChartView, values:[Double], stats:Stats, pastMonths:Int) {
        
        lineChart.userInteractionEnabled = false
        
        // Sets previous date six months back
        setPreviousDateMonthsBack(pastMonths)
        
        // Get the months between the dates
        let currentMonth = currentDate.month
        let previousMonth = previousDate.month
        
        var index = 0
        
        for month in previousMonth-1..<currentMonth {
            
            // We set the data for the month
            addYValueForXDate(values[month], index: index)
            index += 1
            
            // We set the correct label for the month
            let monthName = getMonthName(month)
            xVals.append(monthName.rawValue)
            
            // We set a different color to the current month
            var color : UIColor!
            if month == currentMonth-1 {
                color = CustomColors.carColor()
                colorsLabel.append(UIColor.blackColor())
            } else {
                color = CustomColors.carColor().colorWithAlphaComponent(0.5)
                colorsLabel.append(UIColor.lightGrayColor())
            }
            colorsCircle.append(color)
            
        }
        
        switch stats {
        case Stats.Incomes:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "$")
            break
        case Stats.SavedGas:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "Miles Offset")
            break
        default:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "CO2 MT’s")
            break
        }
        
        configureChartDataSet()
        
        chartDataEntries.append(lineChartDataSet)
        
        chartData = LineChartData(xVals: xVals, dataSets: chartDataEntries)
        
        lineChart.data = chartData
        lineChart.descriptionText = ""
        lineChart.animate(xAxisDuration: 0.75, yAxisDuration: 0.75)
        
        clearValues()
    }
    
    func configureChartForWeekData(lineChart:LineChartView, values:[Double], stats:Stats) {
        
        lineChart.userInteractionEnabled = false
        
        for index in 0..<7 {
            
            // Sunday's income is in the first position of the array, and it's shown in the last position of the chart
            var income = 0.0
            if index == 6 {
                income = values[0]
            } else {
                income = values[index+1]
            }
            
            chartDataSetEntries.append(ChartDataEntry(value: income, xIndex: index))
            
            let dayName = getDayName(index)
            xVals.append(dayName.rawValue)
            
            // We set a different color to the current day
            var color : UIColor!
            if index == currentDate.weekday-2 {
                color = CustomColors.carColor()
                colorsLabel.append(UIColor.blackColor())
            } else {
                color = CustomColors.carColor().colorWithAlphaComponent(0.5)
                colorsLabel.append(UIColor.lightGrayColor())
            }
            if index==6 && currentDate.weekday==1 {
                color = CustomColors.carColor()
                colorsLabel.append(UIColor.blackColor())
            }
            
            colorsCircle.append(color)
            
        }
        
        switch stats {
        case Stats.Incomes:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "$")
            break
        case Stats.SavedGas:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "Miles Offset")
            break
        default:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "CO2 MT’s")
            break
        }
        
        configureChartDataSet()
        
        chartDataEntries.append(lineChartDataSet)
        
        chartData = LineChartData(xVals: xVals, dataSets: chartDataEntries)
        
        lineChart.data = chartData
        lineChart.descriptionText = ""
        lineChart.animate(xAxisDuration: 0.75, yAxisDuration: 0.75)
        
        clearValues()
        
    }
    
    func configureChartDataSet() {
        
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.fillAlpha = 1.0
        
        // Set font of the labels on top of the circles
        lineChartDataSet.valueFont = UIFont(name: "OpenSans-Bold", size: 11.0)!
        
        // Set colors of the circles
        lineChartDataSet.circleColors = colorsCircle
        
        // Set colors of the labels on top of the circles
        lineChartDataSet.valueColors = colorsLabel
        
        // Draws all the colors set
        lineChartDataSet.drawValuesEnabled = true
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.drawFilledEnabled = true
    }
    
    func clearValues() {
        chartData = LineChartData()
        lineChartDataSet = LineChartDataSet()
        chartDataEntries = [IChartDataSet]()
        chartDataSetEntries = [ChartDataEntry]()
        xVals = [String]()
        colorsCircle = [NSUIColor]()
        colorsLabel = [NSUIColor]()
    }
    
    func setPreviousDateMonthsBack(pastMonths:Int) {
        previousDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Month,
            value: -pastMonths,
            toDate: currentDate,
            options: [])
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
}