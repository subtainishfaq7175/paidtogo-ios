//
//  Double+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 10/27/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

extension Double {
//    var roundTo2f: Double {return Double(round(self*100)/100)  }
//    var roundTo3f: Double {return Double(round(self*1000)/1000) }
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    mutating func roundToTwoDecinalPlace() {
        self = self.rounded(toPlaces: 2)
    }
    
    var toString: String {
        return "\(self)"
    }
}
