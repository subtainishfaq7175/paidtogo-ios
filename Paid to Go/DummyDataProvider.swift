//
//  DummyDataProvider.swift
//  Celebrastic
//
//  Created by Admin on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

class DummyDataProvider: DataProviderService {
    
    static let sharedInstance = DummyDataProvider()
    
    private init () {
        
    }
 
    
    func getNotifications(completion: ([Notification]) -> Void) {
        
        var notificationArray = [Notification]()
        
        for var i in 1 ... 4 {
            
            var notification: Notification = Notification(text: "You earned", detail: "U$D \(i)", imageUrl: "", type: 0)
            if i == 3 {
                notification.type = 1
                notification.imageUrl = "https://developer.apple.com/library/ios/Resources/1197/Images/apple2.png"
            }
            
            
            notificationArray.append(notification)
            
        }
        
        completion(notificationArray)
        
    }
    
 }

