 //
 //  AppDelegate.swift
 //  Paid to Go
 //
 //  Created by MacbookPro on 15/3/16.
 //  Copyright © 2016 Infinixsoft. All rights reserved.
 //
 
 import UIKit
 import XCGLogger
 import FBSDKCoreKit
 
 

 let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.default
    
    log.setup(
        level: .debug,
        showLogIdentifier   : false,
        showFunctionName    : false,
        showThreadName      : false,
        showLevel        : true,
        showFileNames       : true,
        showLineNumbers     : true,
        showDate            : false
    )
    
    
//    log.isEnabledFor(level: XCGLogger.debug)
//        = true // Or set the XcodeColors environment variable in your scheme to YES
//    log.xcodeColors = [
//        .Verbose        : .lightGrey,
//        .Debug          : XCGLogger.XcodeColor(fg: (60, 153, 95)),
//        .Info           : XCGLogger.XcodeColor(fg: (71, 162, 201)),
//        .Warning        : XCGLogger.XcodeColor(fg: (208, 230, 85)),
//        .Error          : XCGLogger.XcodeColor(fg: (199, 20, 50)), // Optionally use a UIColor
//        .Severe         : XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
//    ]
    
    return log
 }()
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url , sourceApplication: sourceApplication, annotation: annotation)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        self.customizeNavigationBar()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.customizeNavigationBar()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    private func customizeNavigationBar() {
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default)
        UINavigationBar.appearance().tintColor = CustomColors.NavbarTintColor()   // Navigation bar buttons color
        UINavigationBar.appearance().titleTextAttributes = [
            
            NSAttributedStringKey.foregroundColor : CustomColors.NavbarTintColor(),
            NSAttributedStringKey.font : UIFont(name: "OpenSans-Semibold", size: 18)!
            
        ]
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
 
