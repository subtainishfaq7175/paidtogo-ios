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
    
    func postRegister(user: User,imageData:Data?, imageName:String?, completion: @escaping (_ user: User?, _ error: String?) -> Void, progresshandler:@escaping (Progress) -> Void) {
        
        let json = Mapper().toJSON(user)

        ConnectionManager.sharedInstance.register(params: json as [String : AnyObject], imageData: imageData, imageName: imageName, apiCompletion: { (responseValue, error) in
            if (error == nil) {
                
                let user = Mapper<User>().map(JSON: responseValue as! [String : Any])
                completion(user, nil)
                return
                
            } else {
                if error! == "USER_NOT_FOUND" {
                    completion(nil, "error_email_not_found".localize())
                } else {
                    completion(nil, self.getError(error: error!))
                }
                return
            }
        }, progresshandler: { (progress) in
            progresshandler(progress)
        })
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

                if error! == "USER_NOT_FOUND" {
                     completion(nil, "error_email_not_found".localize())
                } else {
                     completion(nil, self.getError(error: error!))
                }

                return

            }
        }
    }
    
    func updateProfilePicture(user: User,imageData:Data?, imageName:String?, completion: @escaping (_ user: User?, _ error: String?) -> Void, progresshandler:@escaping (Progress) -> Void) {
        
//        let json = Mapper().toJSON(user)
        
        
        let params = ["access_token": (User.currentUser?.accessToken ?? "") as AnyObject
                      ]
        
        ConnectionManager.sharedInstance.updateProfilePicture(params: params as [String : AnyObject], imageData: imageData, imageName: imageName, apiCompletion: { (responseValue, error) in
            if (error == nil) {
//                completion(nil, nil)
                
                if let user = Mapper<User>().map(JSON: responseValue as! [String : Any]) {
                     completion(user, nil)
                } else {
                    completion(nil, self.getError(error: ""))
                }
                return
                
            } else {
                completion(nil, self.getError(error: error!))
                return
            }
        }, progresshandler: { (progress) in
            progresshandler(progress)
        })
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
        
//        ConnectionManager.sharedInstance.getPoolType(params: poolTypeEnum) { (responseValue, error) in
//
//            if (error == nil) {
//
//                let poolType = Mapper<PoolType>().map(JSON: responseValue as! [String : Any])
//                completion(poolType, nil)
//                return
//
//            } else {
//                completion(nil, self.getError(error: error!))
//                return
//
//            }
//        }
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
    
    func postUpdateProfile(user: User, completion: @escaping (_ user: User?, _ error: String?) -> Void) {

        let params = ["first_name": user.name as AnyObject,
                      "last_name": user.lastName as AnyObject,
                      "email": user.email as AnyObject,
                       "paypal_account": user.email as AnyObject,
                      "access_token": (User.currentUser?.accessToken ?? "") as AnyObject,
                      "user_id": User.currentUser?.userId as AnyObject,
                      ]
        
    ConnectionManager.sharedInstance.updateProfile(params: params) { (responseValue, error) in
            
            if (error == nil) {
                let user = Mapper<User>().map(JSON: responseValue  as! [String : Any])
                completion(user, nil)
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        }
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
//    func getOrganizations(_ userId: String, completion: @escaping (_ organization: ActivePoolsRes?, _ error: String?) -> Void) {
//
//        //        let json = Mapper().toJSON(user)
//
//        ConnectionManager.sharedInstance.activePools(userId) { (responseValue, error) in
//
//            if (error == nil) {
//
//                if let organizations = Mapper<ActivePoolsRes>().map(JSON: (responseValue as! [String : Any]))
//                {
//
//                    completion(organizations, nil)
//
//                }
//                return
//
//            } else {
//
//                completion(nil, self.getError(error: error!))
//                return
//
//            }
//        }
//    }
    
    func postUserActivity(_ poolId: Int, miles: Double, steps:Double, activityType:Int,  completion: @escaping (_ organization: GenericResponse?, _ error: String?) -> Void) {
        
        
        
        
        let params:[String:AnyObject] = ["pool_id":poolId as AnyObject,"access_token":User.currentUser?.accessToken  as AnyObject,"start_date_time":"2017-10-19 23:33:39" as AnyObject,"end_latitude":"-58.623286984147" as AnyObject,"end_longitude":"-58.623286984147" as AnyObject,"miles_traveled":miles as AnyObject,"start_latitude":"-34.648671381877" as AnyObject,"start_longitude":"-58.623290159003" as AnyObject,"total_steps":steps as AnyObject, "end_date_time":"2018-05-14 13:33:39" as AnyObject,"activity_type":activityType as AnyObject]
        
        
        
        //        let json = Mapper().toJSON(user)
        
//        ConnectionManager.sharedInstance.postActivity(params: params) { (responseValue, error) in
//            
//            if (error == nil) {
//                
//                if let organizations = Mapper<GenericResponse>().map(JSON: (responseValue as! [String : Any]))
//                {
//                    
//                    completion(organizations, nil)
//                    
//                }
//                return
//                
//            } else {
//                
//                completion(nil, self.getError(error: error!))
//                return
//                
//            }
//        }
    }

//    func getInvitations(_ userId: String, completion: @escaping (_ invitations: [Invitations]?, _ error: String?) -> Void) {
//
////        let json = Mapper().toJSON(user)
//
//        ConnectionManager.sharedInstance.invitations(params: ["user_id": userId as AnyObject]) { (responseValue, error) in
//
//            if (error == nil) {
//
//                if let invitations = Mapper<Invitations>().mapArray(JSONObject: (responseValue as! [String : Any])["Invitations"])
//                {
//
//                    completion(invitations, nil)
//
//                }
//                return
//
//            } else {
//
//                completion(nil, self.getError(error: error!))
//                return
//
//            }
//        }
//    }
//    func acceptInvitation(_ userId:String, invitationsId: Int,isOrgLinked: Bool, completion: @escaping (_ respose: GenericResponse?, _ error: String?) -> Void) {
//        ConnectionManager.sharedInstance.acceptInvitation(params: ["user_id": userId as AnyObject, "invitation_id": invitationsId as AnyObject], isOrgLinked:isOrgLinked) { (responseValue, error) in
//            if (error == nil) {
//                if let res = Mapper<GenericResponse>().map(JSON: responseValue as! [String : Any]){
//                    res.isLinked = isOrgLinked
//                    completion(res, nil)
//                }
//                return
//            } else {
//                completion(nil, self.getError(error: error!))
//                return
//            }
//        }
//    }
    
    //    MARK: -  Really New Requests
    
    func getSubscribedPools(_ userId: String, startDate:Date, endDate:Date, completion: @escaping (_ pools: [Pool]?, _ error: String?) -> Void) {
        
        //        let json = Mapper().toJSON(user)
    
        ConnectionManager.sharedInstance.userSubscribedPools(userId,
                                                             startDate: startDate.formatedStingYYYY_MM_dd(),
                                                             endDate: endDate.formatedStingYYYY_MM_dd(),
                                                             apiCompletion: { (responseValue, error) in
                                                                
                                                                if (error == nil) {
                
                if let pools : [Pool] = Mapper<Pool>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(pools, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        })
    }
    
    
    func getEligiblePools(_ userId: String, completion: @escaping (_ pools: [Pool]?, _ error: String?) -> Void) {
        
        //        let json = Mapper().toJSON(user)
        
        let lat = String(GeolocationManager.sharedInstance.getCurrentLocationCoordinate().latitude)
        let long = String(GeolocationManager.sharedInstance.getCurrentLocationCoordinate().longitude)
        
//        testting
//        lat = String(31.52036960000001)
//        long = String(74.3587473)
        
        ConnectionManager.sharedInstance.userEligiblePools(userId, lattitude: lat, longitude: long, apiCompletion: { (responseValue, error) in
            
            if (error == nil) {
                
                if let pools : [Pool] = Mapper<Pool>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(pools, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        })
    }
    
    func subcribePool(_ userId:String, poolId: Int, completion: @escaping (_ respose: GenericResponse?, _ error: String?) -> Void) {
        ConnectionManager.sharedInstance.subcribePool(params: ["user_id": userId as AnyObject, "pool_id": poolId as AnyObject]) { (responseValue, error) in
            if (error == nil) {
                if let res = Mapper<GenericResponse>().map(JSON: responseValue as! [String : Any]){
//                    res.isLinked = isOrgLinked
                    completion(nil, nil)
                }
                return
            } else {
                completion(nil, self.getError(error: error!))
                return
            }
        }
    }
    
    func unSubcribePool(_ userId:String, poolId: Int, completion: @escaping (_ respose: GenericResponse?, _ error: String?) -> Void) {
        ConnectionManager.sharedInstance.unSubcribePool(params: ["user_id": userId as AnyObject, "pool_id": poolId as AnyObject]) { (responseValue, error) in
            if (error == nil) {
                if let res = Mapper<GenericResponse>().map(JSON: responseValue as! [String : Any]) {
                    //                    res.isLinked = isOrgLinked
                    completion(nil, nil)
                }
                return
            } else {
                completion(nil, self.getError(error: error!))
                return
            }
        }
    }
    
    func searchPools(withSearchString searchString: String, poolType type:String, completion: @escaping (_ pools: [Pool]?, _ error: String?) -> Void) {
        
        let params = ["name": searchString as AnyObject,
                      "type": type as AnyObject,
                      "created_at":  Date().formatedStingYYYY_MM_dd() as AnyObject
                      ]
        
        ConnectionManager.sharedInstance.searchPool(params:params, apiCompletion: { (responseValue, error) in
            
            if (error == nil) {
                
                if let pools : [Pool] = Mapper<Pool>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(pools, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
            }
        })
        
        
    }
    
    func changePassword(_ oldPassword: String, newPassword: String, completion: @escaping (_ message: String?, _ error: String?) -> Void) {
        
        //        let json = Mapper().toJSON(user)
        
        let user = User.currentUser
        
        let params = ["old_password": oldPassword as AnyObject,
                      "new_password": newPassword as AnyObject,
                      "password_repeat": newPassword as AnyObject,
                      "access_token": (user?.accessToken ?? "") as AnyObject,
                      "user_id": user?.userId as AnyObject,
                      ]
        
        ConnectionManager.sharedInstance.changePassword(params:params,
                                                        apiCompletion: { (responseValue, error) in
                                                            
                                                            if (error == nil) {
                                                                completion("Password Updated Sucessfully", nil)
                                                                return
                                                                
                                                            } else {
                                                                
                                                                completion(nil, self.getError(error: error!))
                                                                return
                                                                
                                                            }
        })
    }
    
    func userBalance(_ userId: String, completion: @escaping (_ pools: [Pool]?, _ error: String?) -> Void) {
        
        //        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.userBalance(userId, apiCompletion: { (responseValue, error) in
            
            if (error == nil) {
                
                if let pools : [Pool] = Mapper<Pool>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(pools, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        })
    }
    
    func userLeaderBoard(_ userId: String, completion: @escaping (_ pools: [Pool]?, _ error: String?) -> Void) {
        
        //        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.userLeaderBoard(userId, apiCompletion: { (responseValue, error) in
            
            if (error == nil) {
                
                if let pools : [Pool] = Mapper<Pool>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(pools, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        })
    }
    
    func getSponsors(_ userId: String, completion: @escaping (_ sponsor: [Sponsor]?, _ error: String?) -> Void) {
        
        //        let json = Mapper().toJSON(user)
        
        ConnectionManager.sharedInstance.userSponsors(userId, apiCompletion: { (responseValue, error) in
            
            if (error == nil) {
                
                if let sponsors : [Sponsor] = Mapper<Sponsor>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(sponsors, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        })
    }
    
    
    func userActivities(_ userId: String, completion: @escaping (_ activities: [ActivityNotification]?, _ error: String?) -> Void) {
        
        ConnectionManager.sharedInstance.userActivities(userId, apiCompletion: { (responseValue, error) in
            
            if (error == nil) {
                
                if let activities : [ActivityNotification] = Mapper<ActivityNotification>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(activities, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        })
    }
    
    func registerActivites(_ activities: [AnyObject], completion: @escaping (_ respose: AnyObject?, _ error: String?) -> Void)  {
        ConnectionManager.sharedInstance.registerActivity(params: activities, apiCompletion: { (responseValue, error) in
            if (error == nil) {
//                if let res = Mapper<GenericResponse>().map(JSON: responseValue as! [String : Any]) {
//                   
//                }
                completion(responseValue, nil)
                return
            } else {
                completion(nil, self.getError(error: error!))
                return
            }
        })
    }
    
    func getGraphData(_ userId: String, poolId:String, span:String , completion: @escaping (_ graphData: [ActivityNotification]?, _ error: String?) -> Void) {
        
        ConnectionManager.sharedInstance.graphData(userId, span: span, poolID: poolId, apiCompletion: { (responseValue, error) in
            
            if (error == nil) {
                
                if let graphData : [ActivityNotification] = Mapper<ActivityNotification>().mapArray(JSONArray:responseValue as! [[String : Any]])
                {
                    
                    completion(graphData, nil)
                    
                }
                return
                
            } else {
                
                completion(nil, self.getError(error: error!))
                return
                
            }
        })
    }
    
    func fetchMasterData() {
        ConnectionManager.sharedInstance.fetchMasterData(apiCompletion: { (response, error) in
            if (error == nil) {
    
                if let responseArray = response {
                    
                    let masterData = MasterData()
                    for item in responseArray as! [[String : AnyObject]] {
                        
                        if item["key"] as! String == "calories" {
                            masterData.caloriesPerMile = item["value"] as? Int
                        }
                        if item["key"] as! String == "steps" {
                            masterData.stepsPerMile = item["value"] as? Int
                        }
                        if item["key"] as! String == "gymCheckIn" {
                             masterData.gymCheckIn = item["value"] as? Int
                        }
                        if item["key"] as! String == "traffic" {
                             masterData.trafficPerMile = item["value"] as? Double
                        }
                        if item["key"] as! String == "co2" {
                             masterData.co2OffsetPerMile = item["value"] as? Double
                        }
                        if item["key"] as! String == "profit" {
                             masterData.profit = item["value"] as? Double
                        }
                        if item["key"] as! String == "speedOnFoot" {
                             masterData.speedOnFoot = item["value"] as? Int
                        }
                        if item["key"] as! String == "speedOnBike" {
                             masterData.speedOnBike = item["value"] as? Int
                        }
                    }
                    MasterData.sharedData = masterData;
                }
            } else {
                
            }
        })
    }
    
}

protocol DataProviderService {
    
    func getNotifications(completion: ([Notification]) -> Void)
    //    func getOpenPools(completion: ([Pool]) -> Void)
    //    func getClosedPools(completion: ([Pool]) -> Void)
    
}
