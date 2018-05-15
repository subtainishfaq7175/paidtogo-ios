//
//  DataProvider.swift
//  Celebrastic
//
//  Created by Germán Campagno on 2/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate

class DataProvider : DataProviderService {
    
    // MARK: - Singleton -
    
    static let sharedInstance = DataProvider()
    
    private init () {}
    
    // MARK: - Errors -
    
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
        
        case "USERS_UNSUCCESSFUL":
            return "error"

        case "MYSTATUS_UNSUCCESSFUL":
            return "error_status".localize()
        
        case "ACTIVITY_ROUTE_UNSUCCESSFUL":
            return "The activities route was not tracked"
            
        default:
            return "error_default".localize() + ": " + error
            
        }
        
    }
    
    // MARK: - Auth -
    
    func postRegister(user: User, completion: @escaping (_ user: User?, _ error: String?) -> Void) {

        let json = Mapper().toJSON(user)

        ConnectionManager.sharedInstance.register(params: json as [String : AnyObject]) { (responseValue, error) in

            if (error == nil) {

                let user = Mapper<User>().map(JSON: responseValue as! [String : Any])
                completion(user, nil)
                return

            } else {

                completion(nil, self.getError(error: error!))
                return

            }
        }
    }
    
    func postLogin(user: User, completion: @escaping (_ user: User?, _ error: String?) -> Void) {

        let json = Mapper().toJSON(user)

        ConnectionManager.sharedInstance.login(params: json as [String : AnyObject]) { (responseValue, error) in

            if (error == nil) {

                let user = Mapper<User>().map(JSON: responseValue as! [String : Any])
                completion(user, nil)
                return

            } else {

                completion(nil, self.getError(error: error!))
                return

            }
        }
    }
    
    func postRecoverPassword(user: User, completion: @escaping (_ genericResponse: GenericResponse?, _ error: String?) -> Void) {

        let json = Mapper().toJSON(user)

        ConnectionManager.sharedInstance.forgotPassword(params: json as [String : AnyObject]) { (responseValue, error) in

            if (error == nil) {

                let genericResponse = Mapper<GenericResponse>().map(JSON: responseValue  as! [String : Any])
                completion(genericResponse, nil)
                return

            } else {

                completion(nil, self.getError(error: error!))

                return

            }
        }
    }
    
//    func postFacebookLogin(params: [String: AnyObject], completion: (user: User?, error: String?) -> Void) {
//
//        ConnectionManager.sharedInstance.facebookLogin(params) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let user = Mapper<User>().map(responseValue)
//
//                guard let userID = user?.userId else {
//                    print("EL USERID VINO VACIO!!!")
//                    completion(user: nil, error: "Login with Facebook failed.")
//                    return
//                }
//
//                completion(user: user, error: nil)
//                return
//
//            } else {
//
//                completion(user: nil, error: self.getError(error!))
//                return
//
//            }
//        }
//    }
    
    func postValidateProUser(completion:(_ error: String?) -> Void ) {
        
//        if let receipt = AppleInAppValidator.getReceiptData() {
//            AppleInAppValidator.sharedInstance.verifyReceipt(receipt, completionHandler: { (result, error) in
//                if let error = error {
//                    print("Error: \(error)")
//                    completion(error: error)
//                } else {
//
//                    if let receiptValidationResult = result {
//                        if receiptValidationResult.isValid() {
//                            completion(error: nil)
//                        } else {
//                            completion(error: "Error")
//                        }
//                    }
//                }
//            })
//        } else {
            // The receipt is nil, there is no pro user subscription. By logic, i shouldn't get here...
            print("postValidateProUser - The receipt is nil")
//        }
    }
    
    // MARK: - Notifications -
    
    func getNotifications(completion: ([Notification]) -> Void) {
        DummyDataProvider.sharedInstance.getNotifications(completion: completion)
    }
    
    // MARK: - Pools -
    
func getNationalPools(poolTypeId: String, completion: (_ pools: [Pool]?, _ error: String?) -> Void) {
    getPools(poolTypeId: poolTypeId, open: "2", completion: completion)
    }
    
func getOpenPools(poolTypeId: String, completion: (_ pools: [Pool]?, _ error: String?) -> Void) {
        getPools(poolTypeId: poolTypeId, open: "1", completion: completion)
    }
    
func getClosedPools(poolTypeId: String, completion: (_ pools: [Pool]?, _ error: String?) -> Void) {
    getPools(poolTypeId: poolTypeId, open: "0", completion: completion)
    }
    
    func getPoolType(poolTypeEnum: PoolTypeEnum, completion: @escaping (_ poolType: PoolType?, _ error: String?) -> Void) {
        
    ConnectionManager.sharedInstance.getPoolType(params: poolTypeEnum) { (responseValue, error) in

            if (error == nil) {

                let poolType = Mapper<PoolType>().map(JSON: responseValue as! [String : Any])
                completion(poolType, nil)
                return

            } else {

                completion(nil, self.getError(error: error!))
                return

            }
        }
    }
    
func getPools(poolTypeId: String, open: String, completion: (_ pools: [Pool]?, _ error: String?) -> Void) {
        
        guard let userID = User.currentUser?.userId else {
            return
        }
        
        var params = [
            "open"         : open,
            "pool_type_id" : poolTypeId,
        ]
        
        let lat = String(GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude)
        let lon = String(GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude)
        params["location_lat"] = lat
        params["location_lon"] = lon
        
        // Closed pools should be filtered by the userID. 
        // National pools also require the userID, to determine if it's a Pro user
        if open == "0" || open == "2" {
            params["user_id"] = userID
        }
        
        // National pools shouldn't be filtered by the poolTypId
        if open == "2" {
            params["pool_type_id"] = nil
        }
        
//        ConnectionManager.sharedInstance.getPools(params) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let pools = Mapper<Pool>().mapArray(responseValue)
//                completion(pools: pools, error: nil)
//                return
//
//            } else {
//                if error == "POOL_UNSUCCESSFUL"{
//                    completion(pools: nil, error: nil)
//                    return
//                } else {
//                    completion(pools: nil, error: self.getError(error!))
//                    return
//                }
//
//            }
//        }
    }
    
    // MARK: - Profile -
    
func postUpdateProfile(user: User, completion: (_ user: User?, _ error: String?) -> Void) {
        
        let json = Mapper().toJSON(user)
                
//        ConnectionManager.sharedInstance.updateProfile(json) { (responseValue, error) in
//            
//            if (error == nil) {
//                
//                let user = Mapper<User>().map(responseValue)
//                completion(user: user, error: nil)
//                return
//                
//            } else {
//                
//                completion(user: nil, error: self.getError(error!))
//                return
//                
//            }
//        }
    }
    
    // MARK: - Balance -
    
func postBalance(user: User, completion: (_ balance: Balance?, _ error: String?) -> Void) {
        
        guard let accessToken = User.currentUser?.accessToken else {
            return
        }
        
        guard let userId = User.currentUser?.userId else {
            return
        }
        
        let json = [
            "access_token" : accessToken,
            "user_id" : userId
        ]
        
//        ConnectionManager.sharedInstance.balance(json) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let balance = Mapper<Balance>().map(responseValue)
//                completion(balance: balance, error: nil)
//                return
//
//            } else {
//
//                completion(balance: nil, error: self.getError(error!))
//                return
//
//            }
//        }
    }
    
    // MARK: - Payment -
    
func postPayment(amount: String, type: String, completion: (_ error : String?) -> Void ) {
        
        guard let accessToken = User.currentUser?.accessToken else {
            return
        }
        
        let json = [
            "access_token" : accessToken,
            "amount" : amount,
            "description_text" : "Balance operation",
            "type" : type
        ]
        
//        ConnectionManager.sharedInstance.payment(json) { (responseValue, error) in
//
//            if (error == nil) {
//
//                completion(error: nil)
//
//            } else {
//
//                completion(error: self.getError(error!))
//            }
//        }
    
    }
    
    // MARK: - Activity -
    
func postRegisterActivity(activity: Activity, completion: (_ activityResponse: ActivityResponse?, _ error: String?) -> Void) {
        
        var json = Mapper().toJSON(activity)
        
        // Add the subroute to the API call
        
        let jsonRoute = ActivityManager.getActivityRouteString()
        json.updateValue(jsonRoute, forKey: "activity_route")
        
        
        
//        ConnectionManager.sharedInstance.registerActivity(json) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let activityResponse = Mapper<ActivityResponse>().map(responseValue)
//                completion(activityResponse: activityResponse, error: nil)
//                return
//
//            } else {
//
//                completion(activityResponse: nil, error: self.getError(error!))
//                return
//
//            }
//        }
    }
    
func getActivities(completion: (_ activityNotifications: [ActivityNotification]?, _ error: String?) -> Void) {
        
        
        let userId = User.currentUser?.userId
        
//        ConnectionManager.sharedInstance.getActivities(userId!) { (responseValue, error) in
//
//            if (error == nil) {
//
//                var activityNotifications = Mapper<ActivityNotification>().mapArray(responseValue)
//                activityNotifications?.removeLast() // The last object holds the response call, it's not an object from the model
//
//                completion(activityNotifications: activityNotifications, error: nil)
//                return
//
//            } else {
//
//                completion(activityNotifications: nil, error: self.getError(error!))
//                return
//
//            }
//        }
    }
    
func getActivityRoute(activityId: String, completion: (_ activityRoute: [ActivitySubroute]?, _ error: String?) -> Void) {
        
        let params = [
            "activity_id":activityId
        ]
        
//        ConnectionManager.sharedInstance.getActivityRoute(params) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let activitySubroutes = Mapper<ActivitySubroute>().mapArray(responseValue!["route"])
//
//                completion(activityRoute: activitySubroutes, error: nil)
//
//            } else {
//
//                completion(activityRoute: nil, error: self.getError(error!))
//
//            }
//        }
    }

    // MARK: - Leaderboards -
    
func getLeaderboardsForPool(poolId: String, completion: (_ leaderboard: LeaderboardsResponse?, _ error: String?) -> Void) {
        
        let params = [
            "pool_id" : poolId
        ]
        
//        ConnectionManager.sharedInstance.getLeaderboards(params) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let leaderboard = Mapper<LeaderboardsResponse>().map(responseValue)
//                completion(leaderboard: leaderboard, error: nil)
//                return
//
//            } else {
//                if error == "LEADERBOARDS_UNSUCCESSFUL"{
//                    completion(leaderboard: nil, error: nil)
//                    return
//                } else {
//                    completion(leaderboard: nil, error: self.getError(error!))
//                    return
//                }
//            }
//        }
    }
    
func getLeaderboards(completion: (_ leaderboard: [LeaderboardsResponse]?, _ error: String?) -> Void) {
        
        let userId = User.currentUser?.userId
        
        let params = [
            
            "user_id" : userId,
            
        ]
        
//        ConnectionManager.sharedInstance.getLeaderboards(params as! [String : String]) { (responseValue, error) in
//
//            if (error == nil) {
//
//                var leaderboardsResponse = Mapper<LeaderboardsResponse>().mapArray(responseValue)
//                leaderboardsResponse?.removeLast() // The last object holds the response call, it's not an object from the model
//
//                completion(leaderboard: leaderboardsResponse, error: nil)
//                return
//
//            } else {
//                if error == "LEADERBOARDS_UNSUCCESSFUL"{
//                    completion(leaderboard: nil, error: nil)
//                    return
//                } else {
//                    completion(leaderboard: nil, error: self.getError(error!))
//                    return
//                }
//            }
//        }
    }
    
    // MARK: - Search -
    
func searchUsersByName(username: String, completion: (_ users: [User]?,_ error: String?) -> Void) {

        let params = [
            
            "name" : username,
            
        ]
        
//        ConnectionManager.sharedInstance.searchUsersByName(params) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let users = Mapper<User>().mapArray(responseValue)
//                completion(users: users, error: nil)
//                return
//
//            } else {
//
//                completion(users: nil, error: self.getError(error!))
//                return
//
//            }
//        }
    }
    
    // MARK: - Send Email -
    
    func sendEmailToUsers(users: [String], poolId: String,  completion: (_ result: Bool?,_ error: String?) -> Void) {
        
        let accessToken = User.currentUser?.accessToken
//        let userIDString = arrayToJSONString(array: users)
//
//        let params = [
//
//            "access_token"  : accessToken,
//            "pool_id"       : poolId,
//            "users_id_array": userIDString
//        ]
//
//        print("UserIDs : \(userIDString)")
        
//        ConnectionManager.sharedInstance.postInviteUsers(params as! [String : String]) { (responseValue, error) in
//
//            if (error == nil) {
//
//                completion(result: nil, error: nil)
//                return
//
//            } else {
//
//                completion(result: nil, error: self.getError(error!))
//                return
//
//            }
//        }
    }
    
    // MARK: - Stats -
    
func getStatus(completion: (_ result: Status?,_ error: String?) -> Void) {
        
        guard let accessToken = User.currentUser?.accessToken else {
            return
        }
        
        print("ACCESS TOKEN: \(accessToken)")
        
        let params = [
        
            "access_token" : accessToken
            
        ]
        
//        ConnectionManager.sharedInstance.getMyStatus(params) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let status = Mapper<Status>().map(responseValue)
//
//                completion(result: status, error: nil)
//                return
//
//            } else {
//
//                completion(result: nil, error: self.getError(error!))
//                return
//            }
//
//        }
    }
    
func getStatusWithTimeInterval(fromDate:Date, toDate:Date, completion: (_ result: Status?, _ error: String?) -> Void) {
        
        guard let accessToken = User.currentUser?.accessToken else {
            return
        }
        
        let fromDateString = fromDate.string(custom: "yyyy-MM-dd")
        let toDateString = toDate.string(custom: "yyyy-MM-dd")
                
        let params = [
            
            "access_token"      : accessToken,
            "start_date_time"   : fromDateString,
            "end_date_time"     : toDateString
            
        ]
        
//        ConnectionManager.sharedInstance.getMyStatus(params) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let status = Mapper<Status>().map(responseValue)
//
//                completion(result: status, error: nil)
//                return
//
//            } else {
//
//                completion(result: nil, error: self.getError(error!))
//                return
//            }
//
//        }
    }
    
//    func arrayToJSONString(array: Array<String>) -> String {
//        return array
//            .reduce("") { (acum, userID: String) -> String in
//                if acum.isEmpty {
//                    return "[\(userID)"
//                } else {
//                    return "\(acum),\(userID)"
//                }
//            }
//            .append("]")
//    }

    
    
    //    MARK: - New Requests
    func getOrganizations(_ userId: String, completion: @escaping (_ invitations: [Invitations]?, _ error: String?) -> Void) {
        
        //        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.userActivities(userId) { (responseValue, error) in
            
            if (error == nil) {
                
                if let invitations = Mapper<Invitations>().mapArray(JSONObject: (responseValue as! [String : Any])["Invitations"])
                {
                    
                    completion(invitations, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        }
    }

    func getInvitations(_ userId: String, completion: @escaping (_ invitations: [Invitations]?, _ error: String?) -> Void) {
        
//        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.invitations(params: ["user_id": userId as AnyObject]) { (responseValue, error) in
            
            if (error == nil) {
                
                if let invitations = Mapper<Invitations>().mapArray(JSONObject: (responseValue as! [String : Any])["Invitations"])
                {
                    
                    completion(invitations, nil)

                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        }
    }
    func acceptInvitation(_ userId:String, invitationsId: Int, completion: @escaping (_ respose: GenericResponse?, _ error: String?) -> Void) {
        ConnectionManager.sharedInstance.acceptInvitation(params: ["user_id": userId as AnyObject, "invitation_id": invitationsId as AnyObject]) { (responseValue, error) in
            if (error == nil) {
                if let res = Mapper<GenericResponse>().map(JSON: responseValue as! [String : Any]){
                    completion(res, nil)
                }
                return
            } else {
                completion(nil, self.getError(error: error!))
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
