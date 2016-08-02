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
    
    // Input:yyyy-MM-dd HH:mm:ss - Output:dd/MM/yyyy (String)
    static func getDateStringWithFormatddMMyyyy(dateString:String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.dateFromString(dateString)
        
        guard let dateStringUpdated = date!.toString(DateFormat.Custom("dd/MM/yyyy")) else {
            return ""
        }

        return dateStringUpdated
    }
    
    // Input:Input:yyyy-MM-dd HH:mm:ss - Output:dd/MM/yyyy HH:mm:ss (NSDate)
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
        
        if comparisonResult.rawValue <= 0 {
            // Pool date is previous to current date
            return true
        } else {
            // Post date is posterior to current date
            return false
        }
    }
}