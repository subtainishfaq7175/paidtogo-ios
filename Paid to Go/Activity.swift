//
//  Activity.swift
//  Paid to Go
//
//  Created by Germán Campagno on 12/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class Activity: Mappable {
    
    var startLatitude: Double?
    var startLongitude: Double?
    var endLatitude: Double?
    var endLongitude: Double?
    var poolId: String?
    var startDateTime: String?
    var milesTraveled: String?
    var photography: String?
    var accessToken: String?
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        startLatitude       <-  map["start_latitude"]
        startLongitude      <-  map["start_longitude"]
        endLatitude         <-  map["end_latitude"]
        endLongitude        <-  map["end_longitude"]
        poolId              <-  map["pool_id"]
        startDateTime       <-  map["start_date_time"]
        milesTraveled       <-  map["miles_traveled"]
        photography         <-  map["photo"]
        accessToken         <-  map["access_token"]
        
    }
    
}
