//
//  Transaction.swift
//  Paid to Go
//
//  Created by Germán Campagno on 10/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class Transaction: Mappable {
    
    var paymentId: Int?
    var amount: Int?
    var dateTime: String?
    var description: String?
    var type: String?
    
    
    
    init() {
        self.paymentId = 0
        self.amount = 0
        self.dateTime = ""
        self.description = ""
        self.type = ""
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        paymentId           <- map["payment_id"]
        amount              <- map["amount"]
        dateTime            <- map["date_time"]
        description         <- map["description_text"]
        type                <- map["type"]
    }
    
}


