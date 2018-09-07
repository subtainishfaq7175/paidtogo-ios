//
//  Sponsor.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 11/08/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

public class Sponsor: Mappable {
    
    var id: Int?
    var title: String?
    var description: String?
    var url: String?
    var banner: String?
    var status: Int?
    var userId: Int?
    var createdDateTime: String?
    var updatedDateTime: String?
    
    init() {
        id = Constants.consShared.ZERO_INT

    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        banner <- map["banner"]
        banner = "https://www.paidtogo.com/images/sponsors/" + banner!
        
        status <- map["status"]
        userId <- map["user_id"]
        createdDateTime <- map["created_at"]
        updatedDateTime <- map["updated_at"]
    }
}

