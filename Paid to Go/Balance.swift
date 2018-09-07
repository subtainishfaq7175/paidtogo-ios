//
//  GenericResponse.swift
//  Paid to Go
//
//  Created by MacbookPro on 28/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

public class Balance: Mappable {
    
    var earnedMoney: Double?
    var earnedPoints: Double?
    
    var balance: Int?
    var transactions: [Transaction]?
    var earned: String?
    var redemed: String?
    var pending: String?
    
    init() {
//        self.balance = 0
        
        earnedMoney = 0
        earnedPoints = 0
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        earnedMoney <- map["earned_money"]
        earnedPoints <- map["earned_points"]
        
        balance <- map["balance"]
        transactions <- map["transactions"]

        earned <- map["earned"]
        if !((earned?.characters.count) != nil) {
            earned = "0"
        }

        redemed <- map["redeem"]
        if !((redemed?.characters.count) != nil) {
            redemed = "0"
        }

        pending <- map["pending"]
        if !((pending?.characters.count) != nil) {
            pending = "0"
        }
    }
    
}
