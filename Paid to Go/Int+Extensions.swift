//
//  Int+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 14/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

extension Int {

    var toCGFloat:CGFloat{
        return CGFloat(self)
    }
    var toFloat:Float{
        return Float(self)
    }
    var toDouble:Double{
        return Double(self)
    }
    var toString:String{
        return "\(self)"
    }
    
    var ordinal: String {
        switch (self % 10) {
        case 1:  return "st";
        case 2:  return "nd";
        case 3:  return "rd";
        default: return "th";
        }
    }
}
