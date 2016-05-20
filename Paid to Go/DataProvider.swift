//
//  DataProvider.swift
//  Celebrastic
//
//  Created by Germán Campagno on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper


class DataProvider : DataProviderService {
    
    static let sharedInstance = DataProvider()
    
    private init () {
        
    }
    
    func getError(error: String) -> String {
        switch error {
            
        case "ERRORS":
            return "error_wrong_email_format".localize()
            
        case "USER_NOT_FOUND":
            return "error_user_not_found".localize()
            
        case "USER_EXISTS":
            return "error_user_exists".localize()
        
        case "error_connection":
                return "error_connection".localize()
            
        default:
            return "error_default".localize() + ": " + error
            
        }

    }
    
    
    func getNotifications(completion: ([Notification]) -> Void) {
        DummyDataProvider.sharedInstance.getNotifications(completion)
    }
    
    func getOpenPools(poolTypeId: String, completion: (pools: [Pool]?, error: String?) -> Void) {
        getPools(poolTypeId, open: "1", completion: completion)
    }
    
    func getClosedPools(poolTypeId: String, completion: (pools: [Pool]?, error: String?) -> Void) {
        getPools(poolTypeId, open: "0", completion: completion)
    }
    
    func postRegister(user: User, completion: (user: User?, error: String?) -> Void) {
        
        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.register(json) { (responseValue, error) in
            
            if (error == nil) {
                
                let user = Mapper<User>().map(responseValue)
                completion(user: user, error: nil)
                return
                
            } else {
                
                completion(user: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    func postLogin(user: User, completion: (user: User?, error: String?) -> Void) {
        
        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.login(json) { (responseValue, error) in
            
            if (error == nil) {
                
                let user = Mapper<User>().map(responseValue)
                completion(user: user, error: nil)
                return
                
            } else {
                
                completion(user: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    func postRecoverPassword(user: User, completion: (genericResponse: GenericResponse?, error: String?) -> Void) {
        
        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.forgotPassword(json) { (responseValue, error) in
            
            if (error == nil) {
                
                let genericResponse = Mapper<GenericResponse>().map(responseValue)
                completion(genericResponse: genericResponse, error: nil)
                return
                
            } else {
                
                completion(genericResponse: nil, error: self.getError(error!))
                
                return
                
            }
        }
    }
    
    func postUpdateProfile(user: User, completion: (user: User?, error: String?) -> Void) {
        
        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.updateProfile(json) { (responseValue, error) in
            
            if (error == nil) {
                
                let user = Mapper<User>().map(responseValue)
                completion(user: user, error: nil)
                return
                
            } else {
                
                completion(user: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    func postFacebookLogin(params: [String: AnyObject], completion: (user: User?, error: String?) -> Void) {
        
        
        ConnectionManager.sharedInstance.facebookLogin(params) { (responseValue, error) in
            
            if (error == nil) {
                
                let user = Mapper<User>().map(responseValue)
                completion(user: user, error: nil)
                return
                
            } else {
                
                completion(user: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    func postBalance(user: User, completion: (balance: Balance?, error: String?) -> Void) {
        
        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.balance(json) { (responseValue, error) in
            
            if (error == nil) {
                
                let balance = Mapper<Balance>().map(responseValue)
                completion(balance: balance, error: nil)
                return
                
            } else {
                
                completion(balance: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    func postRegisterActivity(activity: Activity, completion: (activityResponse: ActivityResponse?, error: String?) -> Void) {
        
        let json = Mapper().toJSON(activity)
        
        ConnectionManager.sharedInstance.registerActivity(json) { (responseValue, error) in
            
            if (error == nil) {
                
                let activityResponse = Mapper<ActivityResponse>().map(responseValue)
                completion(activityResponse: activityResponse, error: nil)
                return
                
            } else {
                
                completion(activityResponse: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    func getPoolType(poolTypeEnum: PoolTypeEnum, completion: (poolType: PoolType?, error: String?) -> Void) {
        
        
        ConnectionManager.sharedInstance.getPoolType(poolTypeEnum) { (responseValue, error) in
            
            if (error == nil) {
                
                let poolType = Mapper<PoolType>().map(responseValue)
                completion(poolType: poolType, error: nil)
                return
                
            } else {
                
                completion(poolType: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    func getPools(poolTypeId: String, open: String, completion: (pools: [Pool]?, error: String?) -> Void) {
        
        
        let params = [
            
            "pool_type_id" : poolTypeId,
            "open"         : open
            
        ]
        
        ConnectionManager.sharedInstance.getPools(params) { (responseValue, error) in
            
            if (error == nil) {
                
                let pools = Mapper<Pool>().mapArray(responseValue)
                completion(pools: pools, error: nil)
                return
                
            } else {
                
                completion(pools: nil, error: self.getError(error!))
                return
                
            }
        }
    }
    
    
    
    
}

protocol DataProviderService {
    
    
    func getNotifications(completion: ([Notification]) -> Void)
//    func getOpenPools(completion: ([Pool]) -> Void)
//    func getClosedPools(completion: ([Pool]) -> Void)
    
}