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
    static func getDateWithFormatddMMyyyy(dateString:String) -> NSDate {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return NSDate()
        }
        
        return date as NSDate
    }
    
    func isDatePreviousToCurrentDate() -> Bool {
        let currentDate = NSDate()
        
        let comparisonResult = self.compare(currentDate as Date)
        
        if comparisonResult.rawValue <= 0 {
            // Pool date is previous to current date
            return true
        } else {
            // Post date is posterior to current date
            return false
        }
    }
}
