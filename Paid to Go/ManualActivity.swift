//
//  ManualActivity.swift
//  Paid to Go
//
//  Created by Muhammad Khaliq Rehman on 07/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class ManualActivity: Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kActivityaccess_tokenKey: String = "access_token"
    internal let kActivityuser_idKey: String = "user_id"
    internal let kActivityactivity_typeKey: String = "activity_type"
    internal let kActivitystart_date_timeKey: String = "start_date_time"
    internal let kActivityend_date_timeKey: String = "end_date_time"
    internal let kActivitystart_latitudeKey: String = "start_latitude"
    internal let kActivitystart_longitudeKey: String = "start_longitude"
    internal let kActivityend_latitudeKey: String = "end_latitude"
    internal let kActivityend_longitudeKey: String = "end_longitude"
    internal let kActivitymiles_traveledKey: String = "miles_traveled"
//    internal let kActivitycaloriesKey: String = "calories"
    internal let kActivitytotal_stepsKey: String = "total_steps"
    internal let kActivitycreated_atKey: String = "created_at"
    internal let kActivityupdated_atKey: String = "updated_at"
    internal let kActivityGymIDKey: String = "gym_id"
    
    var startDate: Date?
    var endDate: Date?
    var createdDate: Date?
    var updatedDate: Date?
    
    var currrentSpeed: Double = 0.0
    
    var milesTraveled: Double = 0.0
    var steps: Int = 0
    var gymId: Int?
    
//    var calories: Int = 0
    var type: ActivityTypeEnum = .none
    
    var startLat: Double?
    var startLong: Double?
    var endLat: Double?
    var endLong: Double?
    
    var cyclingPossiblyDetected = false
    
    var co2Offset:Double {
        get {
            return milesTraveled * ((MasterData.sharedData?.co2OffsetPerMile) ?? 0.00082850)
        }
    }
    
    var traffic:Double {
        get {
            return milesTraveled * ((MasterData.sharedData?.trafficPerMile) ?? 0.04)
        }
    }
    
    var calories:Double {
        get {
            return milesTraveled * Double(((MasterData.sharedData?.caloriesPerMile) ?? 100))
        }
    }
    
    
    required init?(map: Map) {
        
    }
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
//    required init(from decoder: Decoder) throws {
//
//    }
//
//    func encode(to encoder: Encoder) throws {
//
//    }

    enum CodingKeys: String, CodingKey {
        
        case milesTraveled
        case steps
        case type
        case startDate
        case endDate
        case createdDate
        case updatedDate
        case startLat
        case startLong
        case endLat
        case endLong
        case gymId
        case cyclingPossiblyDetected
    }
    
  
    
//    // Mappable
//    func mapping(map: Map) {
//
//        startDate       <-  map["start_date_time"]
//        endDate         <-  map["start_date_time"]
//        milesTraveled   <-  map["miles_traveled"]
//        steps           <-  map["steps"]
//    }
//
//
    func toJSON() -> [String : Any] {
        var dictionary: [String : Any] = [:]

        if let startDate = self.startDate {
            dictionary[kActivitystart_date_timeKey] = startDate.formatedStingYYYY_MM_dd_hh_mm_ss()
        } else {
            dictionary[kActivitystart_date_timeKey] = Date().formatedStingYYYY_MM_dd_hh_mm_ss()
        }

        if let endDate = self.endDate {
            dictionary[kActivityend_date_timeKey] = endDate.formatedStingYYYY_MM_dd_hh_mm_ss()
        } else {
            dictionary[kActivityend_date_timeKey] = Date().formatedStingYYYY_MM_dd_hh_mm_ss()
        }

        if let createdDate = self.createdDate {
            dictionary[kActivitycreated_atKey] = createdDate.formatedStingYYYY_MM_dd_hh_mm_ss()
        } else {
            dictionary[kActivitycreated_atKey] = Date().formatedStingYYYY_MM_dd_hh_mm_ss()
        }

        if let updatedDate = self.updatedDate {
            dictionary[kActivityupdated_atKey] = updatedDate.formatedStingYYYY_MM_dd_hh_mm_ss()
        } else {
            dictionary[kActivityupdated_atKey] = Date().formatedStingYYYY_MM_dd_hh_mm_ss()
        }

        dictionary[kActivitymiles_traveledKey] = self.milesTraveled
        dictionary[kActivitytotal_stepsKey] = self.steps
        dictionary[kActivityactivity_typeKey] = self.type.rawValue
//        dictionary[kActivitycaloriesKey] = self.calories

        dictionary[kActivitystart_latitudeKey] = startLat ?? 0.00
        dictionary[kActivityend_latitudeKey] = endLat ?? 0.00
        dictionary[kActivitystart_longitudeKey] = startLong ?? 0.00
        dictionary[kActivityend_longitudeKey] = endLong ?? 0.00

        if let userID  = User.currentUser?.userId {
             dictionary[kActivityuser_idKey] = userID
        } else {
//            dictionary[kActivityuser_idKey] = Date()
        }

        if let gymID = gymId {
            dictionary[kActivityGymIDKey] = gymID
        }

        if let accessToken  = User.currentUser?.accessToken {
            dictionary[kActivityaccess_tokenKey] = accessToken
        } else {
//            dictionary[kActivityaccess_tokenKey] = Date()
        }

        return self.dictionaryWithoutEmptyValues(dict: dictionary as [String : AnyObject])
    }
    
    func dictionaryWithoutEmptyValues(dict: [String: AnyObject]) -> [String: AnyObject] {
        var newDictionary = [String: AnyObject]()
        for (key, value) in dict {
            if let val = value as? String, val.isEmpty {
                // ...
            } else {
                newDictionary[key] = value
            }
        }
        return newDictionary
    }
}
