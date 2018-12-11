//
//  GymLocation.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 31/08/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

public class GymLocation : Mappable, Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    
    var lattitude: Double?
    var longitude: Double?
    var name: String?
    var identifier: String?
    var gymId: Int?
    var imageURL: String?
    var checkinDate: Date?
    var lastCheckInDate: Date?
    var timesCheckIns :Int = 0

    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        lattitude <- map["latitude"]
        longitude <- map["longitude"]
        name <- map["name"]
        gymId <- map["id"]
        imageURL <- map["imageUrl"]
        timesCheckIns <- map["checkin_count"]
        
        // As the server is sending String
        if lattitude == nil, longitude == nil {
            var latString: String?
            latString <- map["latitude"]
            
            var longString: String?
            longString <- map["longitude"]
            
            if latString != nil, longString != nil {
                lattitude = Double(latString!)
                longitude = Double(longString!)}
        }
        
        if lattitude != nil, longitude != nil {
            identifier = String(lattitude!) + "," + String(longitude!)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case lattitude
        case longitude
        case name
        case identifier
        case checkinDate
        case timesCheckIns
        case lastCheckInDate
        case imageURL
        case gymId
    }
    
    func isAdayPassedTillLastChectIn() -> Bool {
        var isAdayPassedTillLastChectIn = true
        
        if let lastCheckInDate = lastCheckInDate {
            isAdayPassedTillLastChectIn = !lastCheckInDate.isToday
        }
        
        return isAdayPassedTillLastChectIn
    }
    
    func getDistanceFromCurentLocation() -> Double {
        let distanceBetweenLocations = CLLocationManager.getDistanceBetweenLocations(locA:GeolocationManager.sharedInstance.getCurrentLocation() , locB:CLLocation(latitude: lattitude!, longitude: longitude!))
        
        return distanceBetweenLocations
    }
    
    
}
