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
            let notification: Notification = Notification(text: "You earned", detail: "U$D \(i)", imageUrl: "", type: 0)
            if i == 3 {
                notification.type = 1
                notification.imageUrl = "https://marketingloserastu.files.wordpress.com/2015/03/correr.jpg"
            }
            
            notificationArray.append(notification)
        }
        
        completion(notificationArray)
    }
    
//    func getOpenPools(completion: ([Pool]) -> Void) {
//        var poolsArray = [Pool]()
//        
//        for var i in 1 ... 4 {
//            let pool: Pool = Pool(text: "Hardcoded Pool", imageUrl: "https://marketingloserastu.files.wordpress.com/2015/03/correr.jpg")
//            
//            
//            poolsArray.append(pool)
//        }
//        
//        completion(poolsArray)
//    }
//    
//    func getClosedPools(completion: ([Pool]) -> Void) {
//        var poolsArray = [Pool]()
//        
//        for var i in 1 ... 4 {
//            let pool: Pool = Pool(text: "Hardcoded Pool", imageUrl: "https://marketingloserastu.files.wordpress.com/2015/03/correr.jpg")
//            
//            
//            poolsArray.append(pool)
//        }
//        
//        completion(poolsArray)
//    }
    
    
}

