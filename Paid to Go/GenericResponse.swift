//
//  GenericResponse.swift
//  Paid to Go
//
//  Created by MacbookPro on 28/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class GenericResponse: Mappable {
    
    var detail: String?
    var code: String?
    var isLinked: Bool?

    
    
    init() {
        self.detail = ""
        self.code = ""
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        detail          <- map["detail"]
        code            <- map["code"]
    }
    
}
