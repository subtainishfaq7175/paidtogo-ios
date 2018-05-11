//
//  Invitations.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 11/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class Invitations: Mappable {
    
    var id: Int!
    var pool: Pool?
    var user: User?
    
    init() {
         id = Constants.consShared.ZERO_INT
         pool = nil
         user = nil
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id              <- map["id"]
        user         <- map["user"]
        pool           <- map["pool"]
    }
}


