//
//  ColorConstants.swift
//  Celebrastic
//
//  Created by MacbookPro on 18/2/16.
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
    private static func whitePinkColor() ->UIColor {
        return UIColor(rgba: "#ffd9d3")
    }
    
    //Photo Detail background color
    private static func whitePinkColorf7() -> UIColor {
        return UIColor(rgba:"#f7ded9")
    }
    
    private static func customGrayColor(value:String) -> UIColor {
        return UIColor(rgba: value)
    }
    
    
    static func NavbarBackground () -> UIColor {
        return greenColor()
    }
    
    static func NavbarTintColor () -> UIColor {
        return whitePinkColor()
    }
    
    static func photoDetailPinkColor () -> UIColor {
        return whitePinkColorf7()
    }
    
    static func unSeenNotificationColor () -> UIColor {
        return whitePinkColor()
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
