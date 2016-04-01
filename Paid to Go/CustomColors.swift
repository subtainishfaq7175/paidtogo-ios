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
    private static func greenColor() -> UIColor{
        return UIColor(rgba: "#6eff93")
    }
    
    //Navbar tint color
    private static func grayColor() ->UIColor {
        return UIColor(rgba: "#454544")
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
        return greenColor()
    }
    
    static func NavbarTintColor () -> UIColor {
        return grayColor()
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
