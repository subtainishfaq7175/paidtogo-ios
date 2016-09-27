//
//  User.swift
//  Paid to Go
//
//  Created by MacbookPro on 22/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

enum UserType : String {
    case Normal = "0",
            Pro = "2";
}

class User: Mappable {
    
    var name: String?
    var lastName: String?
    var email: String?
    var password: String?
    var bio: String?
    var profilePicture: String?
    var paypalAccount: String?
    
    var accessToken: String?
    var paymentToken: String?
    var userId: String?
    
    var type: String?
    
    // MARK: Locally persisted, no API
    
    var age: String?
    var gender: String?
    
    var profileOption1 = false
    var profileOption2 = false
    var profileOption3 = false
    
    var commuteTypeWalkRun = false
    var commuteTypeBike = false
    var commuteTypeBusTrain = false
    var commuteTypeCar = false
    
    init() {
        self.name = ""
        self.lastName = ""
        self.email = ""
        self.password = ""
        self.bio = ""
        self.profilePicture = ""
        self.accessToken = ""
        self.paymentToken = ""
        self.userId = ""
        self.paypalAccount = ""
        self.type = ""
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
    
    func isPro() -> Bool {
        if self.type == UserType.Pro.rawValue {
            return true
        }
        
        return false
    }
    
    static func setProUser() {
        currentUser!.type = UserType.Pro.rawValue
    }
    
    // Mappable
    func mapping(map: Map) {
        
        email               <- map["email"]
        name                <- map["first_name"]
        lastName            <- map["last_name"]
        password            <- map["password"]
        bio                 <- map["bio"]
        profilePicture      <- map["profile_picture"]
        accessToken         <- map["access_token"]
        userId              <- map["user_id"]
        paypalAccount       <- map["paypal_account"]
        type                <- map["user_type"]
        paymentToken        <- map["payment_token"]
        
        age                 <- map["age"]
        gender              <- map["gender"]
        profileOption1      <- map["profile_option_1"]
        profileOption2      <- map["profile_option_2"]
        profileOption3      <- map["profile_option_3"]
        commuteTypeWalkRun  <- map["walk"]
        commuteTypeBike     <- map["bike"]
        commuteTypeBusTrain <- map["bus"]
        commuteTypeCar      <- map["car"]
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
