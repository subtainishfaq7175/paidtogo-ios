//
//  Status.swift
//  Paid to Go
//
//  Created by Nahuel on 30/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class Status: Mappable {
    
    var incomes: Double?
    var savedGas: Double?
    var carbonOff: String?
    var calories: String?
    
    init() {
        
    }

    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        incomes             <-  map["saved_calories"]
        savedGas            <-  map["earned_money"]
        carbonOff           <-  map["saved_co2"]
        calories            <-  map["saved_gas"]
        
    }
}