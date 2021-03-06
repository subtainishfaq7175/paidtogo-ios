//
//  ProUserSubscription.swift
//  Paid to Go
//
//  Created by Nahuel on 23/8/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

public struct ProUser {
    
    // BundleID chosen when registering this app's App ID in the Apple Member Center.
    
    public static let ProUserSubscription = "com.aaronevans.paidtogo.prouser"
    
//    public static let ProUserSubscription = "test.subscription"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [ProUser.ProUserSubscription]
    public static let store = IAPHelper(productIds: ProUser.productIdentifiers)
    
}

func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
