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
     Adds the value for the corresponding date (Y axis)
     
     - parameter value: ammount (earnings, gas saved, carbon offset)
     - parameter index: date (month or day)
     */
    func addYValueForXDate(value:Double, index:Int) {
        let chartDataSetEntry = ChartDataEntry(value: value, xIndex: index)
        chartDataSetEntries.append(chartDataSetEntry)
    }
    
    /**
     Adds the corresponding date (X axis)
     
     - parameter date: type of date (month or day)
     */
    func addXDate(date:String) {
        xVals.append(date)
    }
    
    func configureLabelAmountForTimePeriod(values:[Double], timePeriod:TimePeriod) {
        switch timePeriod {
        case TimePeriod.SixMonths:
            
            break
        case TimePeriod.ThreeMonths:
            
            break
        default:
            
            break
        }
    }
    
    func configureChartForMonthsData(lineChart:LineChartView, values:[Double], stats:Stats, pastMonths:Int, inout totalValues:[Double]) {
        
        lineChart.userInteractionEnabled = false
        
        // Sets previous date from months back (6 or 3)
        setPreviousDateMonthsBack(pastMonths)
        
        // Get the months between the dates
        let currentMonth = currentDate.month
        var previousMonth = previousDate.month
        previousMonth -= 1

        var total = 0.0
        
        for index in 0..<pastMonths+1 {
            
            // We set the data for the month
            addYValueForXDate(values[previousMonth], index: index)
            total += values[previousMonth]
            
            // We set the correct label for the month
            let monthName = getMonthName(previousMonth)
            addXDate(monthName.rawValue)
            
            // We set a different color to the current month
            var color : UIColor!
            if previousMonth == currentMonth-1 {
                color = CustomColors.carColor()
                colorsLabel.append(UIColor.blackColor())
            } else {
                color = CustomColors.carColor().colorWithAlphaComponent(0.5)
                colorsLabel.append(UIColor.lightGrayColor())
            }
            colorsCircle.append(color)
            
            // We validate if the previous month is December. If it is, we set its next value to January
            if previousMonth == 11 {
                previousMonth = 0
            } else {
                previousMonth += 1
            }
        }
        
        switch stats {
        case Stats.Incomes:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "$")
            totalValues[0] = total
            break
        case Stats.SavedGas:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "Miles Offset")
            totalValues[1] = total
            break
        default:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "CO2 MT’s")
            totalValues[2] = total
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
    
    func configureChartForWeekData(lineChart:LineChartView, values:[Double], stats:Stats, inout totalValues:[Double]) {
        
        lineChart.userInteractionEnabled = false
        
        var total = 0.0
        
        for index in 0..<7 {
            
            // Sunday's income is in the first position of the array, and it's shown in the last position of the chart
            var income = 0.0
            if index == 6 {
                income = values[0]
            } else {
                income = values[index+1]
            }
            
            // We set the data for the day
            addYValueForXDate(income, index: index)
            total += income
            
            // We set the correct label for the day
            let dayName = getDayName(index)
            addXDate(dayName.rawValue)
            
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
            totalValues[0] = total
            break
        case Stats.SavedGas:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "Miles Offset")
            totalValues[1] = total
            break
        default:
            lineChartDataSet = LineChartDataSet(yVals: chartDataSetEntries, label: "CO2 MT’s")
            totalValues[2] = total
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
