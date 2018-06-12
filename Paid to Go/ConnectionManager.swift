//
//  ConnectionManager.swift
//  Paid to Go
//
//  Created by Germán Campagno on 22/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

private enum RequestType: String {
    case Request    = "Request"     ;
    case Response   = "Response"    ;
}

class ConnectionManager {
    
//    private var baseURL = "https://www.paidtogo.com/api/v1"
// local server
    private var baseURL = "http://192.168.0.14:8000/api/v1"
// newlly create requests according to new design
    private var invitationsURL: String { return "\(baseURL)/getInvitations" }
    private var userActivitiesURL: String { return "\(baseURL)/userActivities?user_id=" }
    private var recjectInvitationURL: String { return "\(baseURL)/rejectInvitation" }


//    old requests used into new design
    private var registerURL: String { return "\(baseURL)/register" }
    private var loginURL: String { return "\(baseURL)/login" }
    private var forgotPasswordURL : String { return "\(baseURL)/recover_pass" }
    private var acceptInvitationURL : String { return "\(baseURL)/acceptInvitation" }
    private var updateProfileURL : String { return "\(baseURL)/update_profile" }
    private var activePool: String { return "\(baseURL)/activePools" }

    
//    old requests list
    private var balanceURL : String { return "\(baseURL)/balance" }
    private var paymentURL : String { return "\(baseURL)/payment" }
    private var poolTypesURL : String { return "\(baseURL)/pool_types" }
    private var registerActivityURL : String { return "\(baseURL)/register_activity" }
    private var poolsURL : String { return "\(baseURL)/pools" }
    private var leaderboardsURL : String { return "\(baseURL)/leaderboards" }
    private var activityURL : String { return "\(baseURL)/activity" }
    private var userURL : String { return "\(baseURL)/users" }
    private var usersInviteURL : String { return "\(baseURL)/invite_users" }
    private var mystatusURL : String { return "\(baseURL)/mystatus" }
    private var activityRouteURL : String { return "\(baseURL)/activity_route" }
    private var proUserValidationURL : String { return "https://buy.itunes.apple.com/verifyReceipt" }
    
    private var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: - Singleton
    static let sharedInstance = ConnectionManager()
    private init() {
        
    }
}

func dictionaryWithoutEmptyValues(dict: [String: AnyObject]) -> [String: AnyObject] {
    var newDictionary = [String: AnyObject]()
    for (key, value) in dict {
        if let val = value as? String, val.isEmpty {
            // ...
        } else {
            newDictionary[key] = value
        }
    }
    return newDictionary
}

extension ConnectionManager {
//
//
//    // MARK:- Login/Register
//
    func register(params: [String: AnyObject], apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {

        let identifier = "Register API - POST"
        self.postRequest(identifier: identifier, url: self.registerURL, params: params, apiCompletion: apiCompletion)

    }
//
    func login(params: [String: AnyObject], apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {

        let identifier = "Login API - POST"
        self.postRequest(identifier: identifier, url: self.loginURL, params: params, apiCompletion: apiCompletion)
//        self.postRequest(identifier, url: self.loginURL, params: params, apiCompletion: apiCompletion)

    }
//
    func forgotPassword(params: [String: AnyObject], apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {

        let identifier = "Forgot PW API - POST"
        self.postRequest(identifier: identifier, url: self.forgotPasswordURL, params: params, apiCompletion: apiCompletion)

    }
    

    func updateProfile(params: [String: AnyObject], apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {

        let identifier = "Update Profile API - POST"
        self.postRequest(identifier: identifier, url: self.updateProfileURL, params: params, apiCompletion: apiCompletion)

    }
//
//    func facebookLogin(params: [String: AnyObject], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Facebook Login API - POST"
//        self.postRequest(identifier, url: self.loginURL, params: params, apiCompletion: apiCompletion)
//    }
//
//    func validateProUser(params: [String: AnyObject], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Pro User Validation API - POST"
//        self.postRequest(identifier, url: self.loginURL, params: params, apiCompletion: apiCompletion)
//    }
//
//    func balance(params: [String: AnyObject], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Balance API - POST"
//        self.postRequest(identifier, url: self.balanceURL, params: params, apiCompletion: apiCompletion)
//
//    }
//
//    func payment(params: [String: AnyObject], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Payment API - POST"
//        self.postRequest(identifier, url: self.paymentURL, params: params, apiCompletion: apiCompletion)
//    }
//
//    func registerActivity(params: [String: AnyObject], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Register Activity API - POST"
//        self.postRequest(identifier, url: self.registerActivityURL, params: params, apiCompletion: apiCompletion)
//
//    }
//
//    func getPools(params: [String: AnyObject], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Pools API - POST"
//        self.postRequest(identifier, url: self.poolsURL, params: params, apiCompletion: apiCompletion)
//
//    }
//
//    func getLeaderboards(params: [String: String], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Leaderboards API - POST"
//        self.postRequest(identifier, url: self.leaderboardsURL, params: params, apiCompletion: apiCompletion)
//
//    }
//
//    func getActivities(userId: String, apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Activity API - GET"
//        let url = "\(self.activityURL)?user_id=\(userId)"
//        self.getRequest(identifier, url: url, apiCompletion: apiCompletion)
//
//    }
//
//    func getActivityRoute(params: [String: String], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Activity Route API - GET"
//        self.postRequest(identifier, url: self.activityRouteURL, params: params, apiCompletion: apiCompletion)
//    }
//
    
    //    MARK: - NEW REQUESTS
    func userActivities(_ userId:String,apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {
        let identifier = "USER ACTIVITIES API - GET"
        self.getRequest(identifier: identifier, url: self.userActivitiesURL + userId, apiCompletion: apiCompletion)
        
    }
    func activePools(_ userId:String,apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {
        let identifier = "ACTIVE POOLS API - POST"
        let params:[String: AnyObject] = ["user_id": userId as AnyObject]
        self.postRequest(identifier: identifier, url: self.activePool, params: params, apiCompletion: apiCompletion)
//        self.getRequest(identifier: identifier, url: self.userActivitiesURL + userId, apiCompletion: apiCompletion)
        
    }
    func invitations(params: [String: AnyObject], apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {
        let identifier = "Invitaions API - POST"
        self.postRequest(identifier: identifier, url: self.invitationsURL, params: params, apiCompletion: apiCompletion)
        
    }
    
    func acceptInvitation(params: [String: AnyObject],isOrgLinked: Bool, apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {
        var identifier  = ""
        var url = ""
        if isOrgLinked {
            identifier = "Reject Invitation API - POST"
            url = recjectInvitationURL
        }else {
            identifier = "Accept Invitation API - POST"
            url = acceptInvitationURL
        }
        self.postRequest(identifier: identifier, url: url, params: params, apiCompletion: apiCompletion)
        
    }
    
    
    
    
    func getPoolType(params: PoolTypeEnum, apiCompletion: @escaping (_ responseValue:  AnyObject?, _ error: String?) -> Void) {

        let identifier = "Pool Types API - GET"
        var url: String?

        switch params {
        case .Walk:
            url = self.poolTypesURL + "?id=1"
            break
        case.Bike:
            url = self.poolTypesURL + "?id=2"
            break
        case.Train:
            url = self.poolTypesURL + "?id=3"
            break
        case.Car:
            url = self.poolTypesURL + "?id=4"
            break
        }

        self.getRequest(identifier: identifier, url: url!, apiCompletion: apiCompletion)
    }
//
//    func searchUsersByName(params: [String: String], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "User API - POST"
//        self.postRequest(identifier, url: self.userURL, params: params, apiCompletion: apiCompletion)
//    }
//
//    func postInviteUsers(params: [String: String], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Invite Users API - POST"
//        self.postRequest(identifier, url: self.usersInviteURL, params: params, apiCompletion: apiCompletion)
//    }
//
//    func getMyStatus(params: [String: String], apiCompletion: (responseValue: AnyObject?, error: String?) -> Void) {
//
//        let identifier = "Stats API - GET"
//        self.postRequest(identifier, url: self.mystatusURL, params: params, apiCompletion: apiCompletion)
//    }
}

extension ConnectionManager {
//
    private func printRequest(identifier: String, requestType: RequestType, requestURL: String, value: AnyObject) {
        print(identifier + " - " + requestType.rawValue + " - " + requestURL + " : ")
        print(value)
    }
//
    private func printRequest(identifier: String, requestType: RequestType, requestURL: String) {
        print(identifier + " - " + requestType.rawValue + " - " + requestURL)
    }
//
    func postRequest(identifier: String, url: String,  params: [String: AnyObject], apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {
        
        let paramsDict = dictionaryWithoutEmptyValues(dict: params)
        
        self.printRequest(identifier: identifier,
                          requestType: RequestType.Request,
                          requestURL: url,
                          value: paramsDict as AnyObject)

        Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding(destination: .httpBody), headers: nil)
            .responseJSON { (response) in
                
                guard let value = response.result.value else {
                    print("CONNECTION ERROR: \(response)")
                    apiCompletion(nil, "error_connection")
                    return
                }
                
                self.printRequest(identifier: identifier,
                    requestType: RequestType.Response,
                    requestURL: url,
                    value: value as AnyObject)
                
                if response.result.isSuccess {
                    if response.response?.statusCode == 200 {
                        
                        apiCompletion(value as AnyObject, nil)
                        return
                        
                    }  else {
//                        apiCompletion(value as AnyObject, "error_default")

                        if let errorDetail = (value as AnyObject)["code"] as? String {
                            apiCompletion(value as AnyObject, errorDetail)
                        }  else {
                            apiCompletion(value as AnyObject, "error_default")
                        }
                        return
                    }
                    
                } else if response.result.isFailure {
                    
                    apiCompletion(value as AnyObject, "error_connection")
                    
                    return
                }
        }
    }
//
//    
//
//    
//    
    private func getRequest(identifier: String, url: String, apiCompletion: @escaping (_ responseValue: AnyObject?, _ error: String?) -> Void) {
        
        
        
        self.printRequest(identifier: identifier,
                          requestType: RequestType.Request,
                          requestURL: url)
        //        Alamofire
        //            .request(Method.GET, url,  encoding: ParameterEncoding.JSON, headers: nil)

        Alamofire
            .request(url, method: .get)
            .responseJSON { (response) in
                
                guard let value = response.result.value else {
                    apiCompletion(nil, "error_connection")
                    return
                }
                
                
                self.printRequest(identifier: identifier,
                    requestType: RequestType.Response,
                    requestURL: url,
                    value: value as AnyObject)
                
                if response.result.isSuccess {
                    if response.response?.statusCode == 200 {
                        
                        apiCompletion(value as AnyObject, nil)
                        return
                        
                    }  else {
                        
                        if let errorDetail = (value as AnyObject)["code"] as? String {
                            apiCompletion(value as AnyObject, errorDetail)
                        }  else {
                            apiCompletion(value as AnyObject, "error_default".localize())
                        }
                        return
                    }
                    
                } else   if response.result.isFailure {
                    
                    apiCompletion(value as AnyObject, "error_connection".localize())
                    
                    return
                }
        }
    }
    
}

