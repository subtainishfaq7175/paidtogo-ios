//
//  LeaderboardPosition.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 11/08/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

public class LeaderboardPosition: Mappable {
    
    var firstName: String?
    var lastName: String?
    var profile_picture: String?
    var earned_money: Double?
    var earned_points: Double?
    var milesTraveled: Double?
    
    init() {
        earned_money = 0
        earned_points = 0
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        profile_picture <- map["profile_picture"]
        earned_money <- map["earned_money"]
        earned_points <- map["earned_points"]
        milesTraveled <-  map["miles_traveled"]
        
        milesTraveled?.roundToTwoDecinalPlace()
        earned_money?.roundToTwoDecinalPlace()
        earned_points?.roundToTwoDecinalPlace()
    }
}
