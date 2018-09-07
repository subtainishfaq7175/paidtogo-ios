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
    
    var milesTraveled: Double = 0
    var totalSteps: Double = 0
    var savedCalories: Double = 0
    var earnedMoney: Double = 0
    var earnedPoints: Int = 0
    var savedGas: Double = 0
    var savedCo2: Double = 0
    var traffic : Double = 0
    
    init() {
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        
        
        
        savedCalories       <-  map["calories"]
        earnedMoney         <-  map["earned_money"]
        earnedPoints        <-  map["earned_points"]
        savedCo2            <-  map["co2"]
        savedGas            <-  map["saved_gas"]
        milesTraveled       <-  map["miles"]
        totalSteps          <-  map["steps"]
        traffic             <-  map["traffic"]
        
        
        savedCalories.roundToTwoDecinalPlace()
        earnedMoney.roundToTwoDecinalPlace()
        savedCo2.roundToTwoDecinalPlace()
        savedGas.roundToTwoDecinalPlace()
        milesTraveled.roundToTwoDecinalPlace()
        totalSteps.roundToTwoDecinalPlace()
        traffic.roundToTwoDecinalPlace()
    }
}
