//
//  DataProvider.swift
//  Celebrastic
//
//  Created by Admin on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation


class DataProvider : DataProviderService {
    
    static let sharedInstance = DataProvider()
    
    private init () {
        
    }
    
    
    func getNotifications(completion: ([Notification]) -> Void) {
        
        DummyDataProvider.sharedInstance.getNotifications(completion)
        
    }
    

}

protocol DataProviderService {
    

    func getNotifications(completion: ([Notification]) -> Void)
    
}