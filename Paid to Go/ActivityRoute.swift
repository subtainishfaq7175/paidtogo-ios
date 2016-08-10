//
//  ActivityRoute.swift
//  Paid to Go
//
//  Created by Nahuel on 9/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivityRoute: Mappable {

    var activityRoute : [ActivitySubroute]?
    
    init() {
    
    }
    
    required init?(_ map: Map) {
    
    }
    
    func mapping(map: Map) {
        
        activityRoute <- map["activity_route"]
    }

}
