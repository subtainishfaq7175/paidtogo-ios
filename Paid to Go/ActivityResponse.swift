//
//  ActivityResponse.swift
//  Paid to Go
//
//  Created by MacbookPro on 19/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivityResponse: Mappable {
    
    var savedCalories: String?
    var earnedMoney: Double?
    var savedGas: String?
    var savedCo2: String?
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        savedCalories       <-  map["saved_calories"]
        earnedMoney         <-  map["earned_money"]
        savedCo2            <-  map["saved_co2"]
        savedGas            <-  map["saved_gas"]
        
    }
    
}