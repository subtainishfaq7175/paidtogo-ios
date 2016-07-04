//
//  Status.swift
//  Paid to Go
//
//  Created by Nahuel on 30/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

public class Status: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kStatusIncomes: String = "incomes"
    internal let kStatusSavedGas: String = "saved_gas"
    internal let kStatusCarbonOff: String = "carbon_off"
    internal let kStatusCalories: String = "calories"
    
    public var incomes: StatusType?
    public var savedGas: StatusType?
    public var carbonOff: StatusType?
    public var calories: StatusType?
    
    init() {
        
    }

    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        
        incomes             <-  map[kStatusIncomes]
        savedGas            <-  map[kStatusSavedGas]
        carbonOff           <-  map[kStatusCarbonOff]
        calories            <-  map[kStatusCalories]
        
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
        if incomes != nil {
            dictionary.updateValue(incomes!.dictionaryRepresentation(), forKey: "incomes")
        }
        
        return dictionary
    }
}