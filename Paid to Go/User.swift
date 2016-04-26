//
//  User.swift
//  Paid to Go
//
//  Created by MacbookPro on 22/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var name: String?
    var lastName: String?
    var email: String?
    var password: String?
    var bio: String?
    var profilePicture: String?
    
    var accessToken: String?
    var userId: Int?
    
    
    init() {
        self.name = ""
        self.lastName = ""
        self.email = ""
        self.password = ""
        self.bio = ""
        self.profilePicture = ""
        self.accessToken = ""
        self.userId = 0

    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        email           <- map["email"]
        name            <- map["first_name"]
        lastName        <- map["last_name"]
        password        <- map["password"]
        bio             <- map["bio"]
        profilePicture  <- map["profile_picture"]
        accessToken     <- map["access_token"]
        userId          <- map["user_id"]
    }
    
/* {
 "access_token": "$2y$10$qNU.rxgqpK/xkLkl7MXdoeIyybU9LjjGMvuxQA2n2jZGeT0LzXw1S",
 "profile_picture": "",
 "user_id": 22,
 "code": "REGISTER_SUCCESS",
 "detail": "User successfully registered."
 } */
}
