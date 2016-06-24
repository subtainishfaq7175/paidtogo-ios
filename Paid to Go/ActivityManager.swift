//
//  ActivityManager.swift
//  Paid to Go
//
//  Created by Nahuel on 23/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

 /// Handles the whole activity process, and the necessary information to update the progress circle

class ActivityManager: NSObject {

    var angle : Double = 0.0
    var activity : Activity = Activity()
    
    /**
     *  Singleton
     */
    static let sharedInstance = ActivityManager()
    
    private override init() {
        
    }
    
    
}
