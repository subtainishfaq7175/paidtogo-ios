//
//  ActivitySubroute.swift
//  Paid to Go
//
//  Created by Nahuel on 9/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper
import MapKit

class ActivitySubroute: Mappable {

    var latitude : String?
    var longitude : String?
    var invisible : String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        invisible <- map["invisible"]
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        
        let initialLatitude = Double((latitude)!)
        let initialLongitude = Double((longitude)!)
        
        let coordinate = CLLocationCoordinate2DMake(initialLatitude!, initialLongitude!)
        
        return coordinate
    }
}
