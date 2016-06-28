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
    
    func toString() -> String {
    
        return "startLatitude: \(startLatitude)\n" +
                "startLongitude: \(startLongitude)\n" +
                "endLatitude: \(endLatitude)\n" +
                "endLongitude: \(endLongitude)\n" +
                "poolId: \(poolId)\n" +
                "startDateTime: \(startDateTime)\n" +
                "milesTraveled: \(milesTraveled)\n" +
                "photography: \(photography)\n" +
                "accessToken: \(accessToken)\n"
    }
    
}

/*
 "StartLatitude \(startLatitude)
 startLongitude
 endLatitude
 endLongitude
 poolId
 startDateTime
 milesTraveled
 photography
 accessToken
 "
 */
