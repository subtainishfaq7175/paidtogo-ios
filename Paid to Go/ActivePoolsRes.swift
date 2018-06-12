//
//  ActivePoolsRes.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 11/06/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivePoolsRes: Mappable {
    
    var sponsorPools: [Pool]? = [Pool]()
    var nationalPool: Pool?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        sponsorPools       <-  map["sponsorPools"]
        nationalPool         <-  map["nationalPool"]
        
    }
}
