//
//  DataProvider.swift
//  Celebrastic
//
//  Created by Admin on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper


class DataProvider : DataProviderService {
    
    static let sharedInstance = DataProvider()
    
    private init () {
        
    }
    
    
    func getNotifications(completion: ([Notification]) -> Void) {
        DummyDataProvider.sharedInstance.getNotifications(completion)
    }
    
    func getOpenPools(completion: ([Pool]) -> Void) {
        DummyDataProvider.sharedInstance.getOpenPools(completion)
    }
    
    func getClosedPools(completion: ([Pool]) -> Void) {
        DummyDataProvider.sharedInstance.getClosedPools(completion)
    }
    
    func postRegister(user: User, completion: (user: User?, error: String?) -> Void) {
        
        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.register(json) { (responseValue, error) in
            
            if (error == nil) {
                
                let user = Mapper<User>().map(responseValue)
                completion(user: user, error: nil)
                return
                
            } else {
                
                completion(user: nil, error: error)
                return
                
            }
        }
    }
    
    
}

protocol DataProviderService {
    
    
    func getNotifications(completion: ([Notification]) -> Void)
    func getOpenPools(completion: ([Pool]) -> Void)
    func getClosedPools(completion: ([Pool]) -> Void)
    
}