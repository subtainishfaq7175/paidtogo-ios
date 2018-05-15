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
    
//    Singalton
    private init(){
        
    }
    
   static let colorShared = CustomColors()
    
    static func getColor(_ rgba:String) -> UIColor {
        do{
            return try UIColor(rgba_throws: rgba)
        }catch{
            return UIColor.white

        }
    }
     func getColorfromString(_ rgba:String) -> UIColor {
        do{
            return try UIColor(rgba_throws: rgba)
        }catch{
            return UIColor.white
            
        }
    }
    
    
    var springGreen:UIColor {
        return getColorfromString("#00FC65")
    }
    
    //Navbar background color
    static func greenColor() -> UIColor{
        
        return getColor("#6eff93")
    }
    
    //Navbar tint color
    private static func grayColor() ->UIColor {
       // return UIColor(rgba: "#454544")
        return getColor( "#333333")
    }
    
    private static func orangeColor() -> UIColor {
        return getColor("#fa9221")
    }
    
    private static func redColor() -> UIColor {
        return getColor( "#f95452")
    }
    
    private static func yellowColor() -> UIColor {
        return getColor("#feec10")
    }
    
    private static func cyanColor() -> UIColor {
        return getColor("#41dafc")
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
        return getColor("#eae9e5")
    }
    
    static func lightBlueColor() -> UIColor {
        return getColor("#34b5fb")
    }
    
    static func lightGrayColor() -> UIColor {
        return UIColor.lightGray.withAlphaComponent(0.5)
    }

    static func headerColor() -> UIColor {
        return getColor( "#303030")
    }

    private static func customGrayColor(value:String) -> UIColor {
        return getColor( value)
    }
    
    
    static func NavbarBackground () -> UIColor {
        return cyanColor()
    }
    
    static func NavbarTintColor () -> UIColor {
        return UIColor.black
    }
   
    
    static func userNameNotificationTextColor () -> UIColor {
        return customGrayColor(value: "#353535")
    }
    
    static func notificationMessageTextColor() -> UIColor {
        return customGrayColor(value: "#424242")
    }
    
    static func notificationActivityIndicatorTextColor () -> UIColor {
        return notificationMessageTextColor()
    }

}
