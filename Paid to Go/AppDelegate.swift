 //
//  AppDelegate.swift
//  Paid to Go
//
//  Created by MacbookPro on 15/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import XCGLogger

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.defaultInstance()
    
    log.setup(
        .Debug,
        showLogIdentifier   : false,
        showFunctionName    : false,
        showThreadName      : false,
        showLogLevel        : true,
        showFileNames       : true,
        showLineNumbers     : true,
        showDate            : false
    )
    
    
    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    log.xcodeColors = [
        .Verbose        : .lightGrey,
        .Debug          : XCGLogger.XcodeColor(fg: (60, 153, 95)),
        .Info           : XCGLogger.XcodeColor(fg: (71, 162, 201)),
        .Warning        : XCGLogger.XcodeColor(fg: (208, 230, 85)),
        .Error          : XCGLogger.XcodeColor(fg: (199, 20, 50)), // Optionally use a UIColor
        .Severe         : XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    ]
    
    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.customizeNavigationBar()

        return true
    }
    
    private func customizeNavigationBar() {
   UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        UINavigationBar.appearance().tintColor = UIColor.darkGrayColor()                                                // Navigation bar buttons color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]   // Navigation bar title attributes

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

