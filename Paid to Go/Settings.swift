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
    case AutotrackingStartDate
    case CheckInsNotification
    case AutotrackingStartDateForCycling
}

class Settings {
    
    // MARK: Keys
    private let initialPopUpAlreadyShownKey = "initialPopUpAlreadyShownKey"
    private let trackingNotRequiredPopUpAlreadyShownKey = "trackingNotRequiredPopUpAlreadyShownKey"
    private let checkInsNotificationKey = "checkInsNotificationKey"
    
    
    var isAutoTrackingOn: Bool {
        get {
            return userdefaults.bool(forKey: DefaultsKeys.Autotracking.rawValue)
        }
        set {
            userdefaults.set(newValue, forKey: DefaultsKeys.Autotracking.rawValue)
            
            if newValue {
                userdefaults.set(Date(), forKey: DefaultsKeys.AutotrackingStartDate.rawValue)
            }
        }
    }
    
    var autoTrackingStartDate : Date? {
        get {
            return userdefaults.object(forKey: DefaultsKeys.AutotrackingStartDate.rawValue) as? Date
        }
        set {
            userdefaults.set(newValue, forKey: DefaultsKeys.AutotrackingStartDate.rawValue)
        }
    }
    
    var autoTrackingStartDateForCycling : Date? {
        get {
            return userdefaults.object(forKey: DefaultsKeys.AutotrackingStartDateForCycling.rawValue) as? Date
        }
        set {
            userdefaults.set(newValue, forKey: DefaultsKeys.AutotrackingStartDateForCycling.rawValue)
        }
    }
    
    var initialPopUpAlreadyShown :Bool {
        get {
            return userdefaults.bool(forKey: initialPopUpAlreadyShownKey)
        }
        set {
            userdefaults.set(newValue, forKey: initialPopUpAlreadyShownKey)
        }
    }
    
    var trackingNotRequiredPopUpAlreadyShown :Bool {
        get {
            return userdefaults.bool(forKey: trackingNotRequiredPopUpAlreadyShownKey)
        }
        set {
            userdefaults.set(newValue, forKey: trackingNotRequiredPopUpAlreadyShownKey)
        }
    }
    
    var checkInsNotification :Bool {
        get {
            return userdefaults.bool(forKey: checkInsNotificationKey)
        }
        set {
            userdefaults.set(newValue, forKey: checkInsNotificationKey)
            if newValue {
                GeolocationManager.sharedInstance.registerForNotification()
            }
        }
    }
    
    
    let userdefaults = UserDefaults.standard
    
    public static let shared = Settings()
    
    private init() {
    
    }
    
}
