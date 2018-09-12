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
    var userIdInt: Int?

    var type: String?

    var userTotalMoney: Double?
    var userTotalPoints: Int?
    
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
    
    // Facebook variable
    
    var facebookId:String?
    var facebookImageUrl:String?
    var islogedInViaFacebook = false
    
    init() {
        self.name = ""
        self.lastName = ""
        self.email = ""
        self.password = ""
        self.bio = ""
        self.profilePicture = ""
        self.accessToken = ""
        self.paymentToken = ""
        self.paypalAccount = ""
        self.type = ""
        self.userTotalMoney = 0
        self.userTotalPoints = 0
    }
    
    required init?(map: Map) {
        
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
    
    func hasPaymentToken() -> Bool {
        if let paymentToken = self.paymentToken  {
            if paymentToken.characters.count > 0 {
                print("User => paymentToken OK!")
                return true
            } else {
                print("User => NO paymentToken")
                return false
            }
        } else {
            print("User => NO paymentToken")
            return false
        }
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
        userIdInt           <- map["user_id"]
        
        facebookId          <- map["fb_id"]
        facebookImageUrl    <- map["image"]
        islogedInViaFacebook <- map["is_facebook"]
        
        if userId == nil {
            if let userIdInt = userIdInt {
                userId = userIdInt.toString
            }
        }
        
        paypalAccount       <- map["paypal_account"]
        type                <- map["user_type"]
        paymentToken        <- map["payment_token"]
        userTotalPoints     <- map["total_points"]
        userTotalMoney      <- map["total_money"]
        
        
        age                 <- map["age"]
        gender              <- map["gender"]
        profileOption1      <- map["profile_option_1"]
        profileOption2      <- map["profile_option_2"]
        profileOption3      <- map["profile_option_3"]
        commuteTypeWalkRun  <- map["walk"]
        commuteTypeBike     <- map["bike"]
        commuteTypeBusTrain <- map["bus"]
        commuteTypeCar      <- map["car"]
        
        userTotalMoney?.roundToTwoDecinalPlace()
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
            let defaults = UserDefaults.standard
//            let userJSON = defaults.object(forKey: currentUserKey)
            guard let userJSON = defaults.object(forKey: currentUserKey) else {
                return nil
            }
            let user = Mapper<User>().map(JSON: userJSON as! [String : Any])
            
            return user
            
        }
        
        set {
            let defaults = UserDefaults.standard
            
            if let newUser = newValue {
                
                let userJSONDict = Mapper().toJSON(newUser)
                defaults.set(userJSONDict, forKey: currentUserKey)
                
            } else {
                
                defaults.set(nil, forKey: currentUserKey)
                
            }
            
            defaults.synchronize()
        }
    }
}
