//
//  CalculatedUnit.swift
//  Paid to Go
//
//  Created by Nahuel on 4/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

public class CalculatedUnit: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kCalculatedUnitDateTime: String = "date_time"
    internal let kCalculatedUnitValue: String = "value"
    
    public var date: String?
    public var value: Double?
    
    init() {
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        
        date             <-  map[kCalculatedUnitDateTime]
        
        var valueString : String = ""
        valueString     <-  map[kCalculatedUnitValue]
        value = Double(valueString) != nil ? Double(valueString) : 0.0
    }
}
