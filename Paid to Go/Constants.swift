//
//  Constants.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 03/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
class Constants {
    public static let consShared = Constants()
    private init(){
        
    }
//    String constants
    let APP_NAME = "Paidtogo"
    let OK_STR = "OK"
    let YES_STR = "Yes"
    let NO_STR = "No"
    let EMPTY_STR = ""
    let NA_STR = "Not Available"

//    Interger Values
    let ZERO_INT:Int  = 0
    let ONE_INT:Int  = 1
    let TWO_INT:Int  = 2
    let THREE_INT:Int  = 3
    let FOUR_INT:Int  = 4
    let FIVE_INT:Int  = 5
    let EIGHT_INT:Int  = 8
    let HUNDRED_INT:Int  = 100
//    Fonts name
    let OPEN_SANS_SEMIBOLD = "OpenSans-Semibold"
    let OPEN_SANS_LIGHT = "OpenSans-Light"

 // Notification
    let NOTIFICATION_LOCATION_UPDATED = "LocationUpdated"
    let NOTIFICATION_DID_EXIT_CURRENT_GYM = "LocationExitCurrentGym"
    let NOTIFICATION_DID_ENTER_CURRENT_GYM = "LocationEnterCurrentGym"
    
    let NOTIFICATION_ACTIVITIES_SYNCED = "activitiesSynced"
//    let NOTIFICATION_USER_IMAGE_UPDATED = "USER_IMAGE_UPDATED"
    let NOTIFICATION_USER_UPDATED = "USER_UPDATED"
    let NOTIFICATION_WELLDONE_SCREEN_APPEARED = "WELLDONE_SCREEN_APPEARED"

}
