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
    var paypalAccount: String?
    
    var accessToken: String?
    var userId: String?
    
    
    init() {
        self.name = ""
        self.lastName = ""
        self.email = ""
        self.password = ""
        self.bio = ""
        self.profilePicture = ""
        self.accessToken = ""
        self.userId = ""
        self.paypalAccount = ""
    }
    
    required init?(_ map: Map) {
        
    }
    
    func fullName() -> String {
        if let name = name {
            if let lastName = lastName {
                return name + " " + lastName
            }
            else {
                return name
            }
        } else {
            return ""
        }
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
        paypalAccount   <- map["paypal_account"]
    }
}

extension User {
    
    static func logout() {
        User.currentUser = nil
    }
    
    static var imagePrefix: String {
        return "data:image/jpeg;base64,"
    }
    
    private static var currentUserKey: String {
        return "CURRENT_USER_PTG"
    }
    
    static var currentUser: User? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let userJSON = defaults.objectForKey(currentUserKey)
            
            let user = Mapper<User>().map(userJSON)
            
            return user
            
        }
        
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let newUser = newValue {
                
                let userJSONDict = Mapper().toJSON(newUser)
                defaults.setObject(userJSONDict, forKey: currentUserKey)
                
            } else {
                
                defaults.setObject(nil, forKey: currentUserKey)
                
            }
            
            defaults.synchronize()
        }
    }
}
