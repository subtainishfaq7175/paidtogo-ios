//
//  NSDate+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 22/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import SwiftDate

extension NSDate {
    
    // Input:2016-09-28 00:00:00 - Output:22/01/2016 (String)
    static func getDateStringWithFormatddMMyyyy(dateString:String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.dateFromString(dateString)
        
        guard let dateStringUpdated = date!.toString(DateFormat.Custom("dd/MM/yyyy")) else {
            return ""
        }

        return dateStringUpdated
    }
    
    // Input:2016-09-28 00:00:00 - Output:22/01/2016 (NSDate)
    static func getDateWithFormatddMMyyyy(dateString:String) -> NSDate {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.dateFromString(dateString) else {
            return NSDate()
        }
        
        return date
    }
    
    func isDatePreviousToCurrentDate() -> Bool {
        let currentDate = NSDate()
        
        let comparisonResult = self.compare(currentDate)
        
        print("Comparison Result : \(comparisonResult)")
        
        if comparisonResult.rawValue <= 0 {
            // Pool date is previous to current date
            return true
        } else {
            // Post date is posterior to current date
            return false
        }
    }
}