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
    
    
    
    init() {
        self.balance = 0
        //        self.transactions = ""
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        balance             <- map["balance"]
        transactions        <- map["transactions"]
    }
    
    
    
}
