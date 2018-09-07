//
//  NSDate+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 22/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    
    // Input:yyyy-MM-dd HH:mm:ss - Output:dd/MM/yyyy (String)
    static func getDateStringWithFormatddMMyyyy(dateString:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            guard let dateStringUpdated = date.string(custom: "yyyy-MM-dd HH:mm:ss") as? String else {
                return ""
            }
            
            return dateStringUpdated
        }
        
        return ""
    }
    
    //  Input:yyyy-MM-dd HH:mm:ss (String)
    //  Output:dd/MM/yyyy HH:mm:ss (String)
    static func getDateStringWithFormatddMMyyyyHHmmss(dateString:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            guard let dateStringUpdated = date.string(custom: "dd/MM/yyyy HH:mm:ss") as? String else {
                return ""
            }
            
            return dateStringUpdated
        }
        
        return ""
    }
    
    // Input:Input:yyyy-MM-dd HH:mm:ss - Output:dd/MM/yyyy HH:mm:ss (NSDate)
    static func getDateWithFormatddMMyyyy(dateString:String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return Date()
        }
        
        return date as Date
    }
    
    func isDatePreviousToCurrentDate() -> Bool {
        let currentDate = Date()
        
        let comparisonResult = self.compare(currentDate as Date)
        
        if comparisonResult.rawValue <= 0 {
            // Pool date is previous to current date
            return true
        } else {
            // Post date is posterior to current date
            return false
        }
    }
    
    
    func formatedStingdd_MMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM"
        
        return dateFormatter.string(from: self as Date)
    }
    
    func formatedStingMMM_YY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-YY"
        
        return dateFormatter.string(from: self as Date)
    }
    
    func formatedStingYYYY_MM_dd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: self as Date)
    }
    
    func formatedStingEEEE_MMM_dd() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE - MMM dd"
        return dateFormatter.string(from: self as Date).uppercased()
    }
    
    func formatedStingYYYY_MM_dd_hh_mm_ss() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self as Date).uppercased()
    }
    
  
    // MARK: Sart and end Dates
    
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self as Date))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: self.startOfWeek)!
    }
    
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self as Date)))!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    var lastWeek: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: noon)!
    }
    
    var lastMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: noon)!
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
