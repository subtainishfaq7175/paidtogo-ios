//
//  GenericResponse.swift
//  Paid to Go
//
//  Created by MacbookPro on 28/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class Balance: Mappable {
    
    var balance: Int?
    var transactions: [Transaction]?
    var earned: String?
    var redemed: String?
    var pending: String?
    
    init() {
        self.balance = 0
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        balance             <- map["balance"]

        transactions        <- map["transactions"]
        
        earned              <- map["earned"]
        if !((earned?.characters.count) != nil) {
            earned = "0"
        }
        
        redemed             <- map["redemed"]
        if !((redemed?.characters.count) != nil) {
            redemed = "0"
        }
        
        pending             <- map["pending"]
        if !((pending?.characters.count) != nil) {
            pending = "0"
        }
    }
    
}
