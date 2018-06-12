//
//  ActivityResponse.swift
//  Paid to Go
//
//  Created by MacbookPro on 19/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

public class ActivityResponse: Mappable {
    
    var milesTraveled: Double?
    var totalSteps: Double?
    var savedCalories: Double?
    var earnedMoney: Double?
    var savedGas: Double?
    var savedCo2: Double?
    
    init() {
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        
        savedCalories       <-  map["saved_calories"]
        earnedMoney         <-  map["earned_money"]
        savedCo2            <-  map["saved_co2"]
        savedGas            <-  map["saved_gas"]
        milesTraveled       <-  map["miles_traveled"]
        totalSteps          <-  map["total_steps"]

        
    }
}
