//
//  StatusType.swift
//  Paid to Go
//
//  Created by Nahuel on 4/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

enum EnumStatusType {
    case Incomes
    case SavedGas
    case CarbonOff
    case Calories
}

public class StatusType: NSObject, Mappable, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kStatusTypeBalanceKey: String = "balance"
    internal let kStatusTypeCalculatedUnits: String = "calculated_units"
    
    var statusType : EnumStatusType?
    var balance: Double?
    var calculatedUnits: [CalculatedUnit]?
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        
        balance             <-  map[kStatusTypeBalanceKey]
        calculatedUnits     <-  map[kStatusTypeCalculatedUnits]
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
//        if balance != nil {
//            dictionary.updateValue(balance!, forKey: "balance")
//        }
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
//        self.detail = aDecoder.decodeObjectForKey(kPoolTypeDetailKey) as? String
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(detail, forKey: kPoolTypeDetailKey)
    }
}
