//
//  ColorConstants.swift
//  Celebrastic
//
//  Created by German Campagno on 18/2/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class CustomColors {
    
    //Navbar background color
    static func greenColor() -> UIColor{
        return UIColor(rgba: "#6eff93")
    }
    
    //Navbar tint color
    private static func grayColor() ->UIColor {
       // return UIColor(rgba: "#454544")
        return UIColor(rgba: "#333333")
    }
    
    private static func orangeColor() -> UIColor {
        return UIColor(rgba: "#fa9221")
    }
    
    private static func redColor() -> UIColor {
        return UIColor(rgba: "#f95452")
    }
    
    private static func yellowColor() -> UIColor {
        return UIColor(rgba: "#feec10")
    }
    
    private static func cyanColor() -> UIColor {
        return UIColor(rgba: "#41dafc")
    }
    
    static func walkRunColor() -> UIColor {
        return orangeColor()
    }
    
    static func bikeColor() -> UIColor {
        return redColor()
    }

    static func busTrainColor() -> UIColor {
        return yellowColor()
    }
    
    static func carColor() -> UIColor {
        return cyanColor()
    }
    
    static func creamyWhiteColor() -> UIColor {
        return UIColor(rgba: "#eae9e5")
    }
    
    static func lightBlueColor() -> UIColor {
        return UIColor(rgba: "#34b5fb")
    }
    

    private static func customGrayColor(value:String) -> UIColor {
        return UIColor(rgba: value)
    }
    
    
    static func NavbarBackground () -> UIColor {
        return cyanColor()
    }
    
    static func NavbarTintColor () -> UIColor {
        return UIColor.blackColor()
    }
   
    
    static func userNameNotificationTextColor () -> UIColor {
        return customGrayColor("#353535")
    }
    
    static func notificationMessageTextColor() -> UIColor {
        return customGrayColor("#424242")
    }
    
    static func notificationActivityIndicatorTextColor () -> UIColor {
        return notificationMessageTextColor()
    }
    

    
    
}
