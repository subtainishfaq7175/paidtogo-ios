//
//  ActivitySubroute.swift
//  Paid to Go
//
//  Created by Nahuel on 9/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivitySubroute: Mappable {

    var latitude : String?
    var longitude : String?
    var invisible : String?
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        latitude <- map["'latitude'"]
        longitude <- map["'longitude'"]
        invisible <- map["'invisible'"]
    }
}
