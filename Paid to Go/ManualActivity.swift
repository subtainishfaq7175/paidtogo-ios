//
//  ManualActivity.swift
//  Paid to Go
//
//  Created by Muhammad Khaliq Rehman on 07/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class ManualActivity: Mappable, Codable {
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var milesTraveled: Double = 0.0
    var steps: Int = 0
    var type: ActivityTypeEnum = .none
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case startDate
        case endDate
        case milesTraveled
        case steps
        case type
    }
    
    // Mappable
    func mapping(map: Map) {

        startDate       <-  map["start_date_time"]
        endDate         <-  map["start_date_time"]
        milesTraveled   <-  map["miles_traveled"]
        steps           <-  map["steps"]
    }
    
}
