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
                notification.imageUrl = "https://www.nasa.gov/sites/default/files/styles/image_card_4x3_ratio/public/thumbnails/image/ccfid_86349_2015314061422_image.jpg?itok=LWja6N9V"
            }
            
            
            notificationArray.append(notification)
            
        }
        
        completion(notificationArray)
        
    }
    
 }

