//
//  Settings.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 07/07/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation

// Make this available globally to your project
// This will ensure your keys are always correct.
enum DefaultsKeys: String {
    case Autotracking
}

class Settings {
    var isAutoTrackingOn: Bool {
        get {
            return userdefaults.bool(forKey: DefaultsKeys.Autotracking.rawValue)
        }
        set {
            userdefaults.set(newValue, forKey: DefaultsKeys.Autotracking.rawValue)
        }
    }
    
    let userdefaults = UserDefaults.standard
    
    public static let shared = Settings()
    
    private init() {
    
    }
    
}
