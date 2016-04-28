//
//  ConnectionManager.swift
//  Paid to Go
//
//  Created by MacbookPro on 22/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

private enum RequestType: String {
    case Request    = "Request"     ;
    case Response   = "Response"    ;
}

//public enum Method: String {
//    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
//}


class ConnectionManager {
    
    private var baseURL = "http://paid.xanthops.com/api/v1"
    
    private var registerURL: String { return "\(baseURL)/register" }
    private var loginURL: String { return "\(baseURL)/login" }
    private var forgotPasswordURL : String { return "\(baseURL)/recover_pass" }
    private var updateProfileURL : String { return "\(baseURL)/update_profile" }
    
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
        if let val = value as? String where val.isEmpty {
            // ...
        } else {
            newDictionary[key] = value
        }
    }
    return newDictionary
}

extension ConnectionManager {

    
    func register(params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let identifier = "Register API - POST"
        self.postRequest(identifier, url: self.registerURL, params: params, apiCompletion: apiCompletion)
        
    }
    
    func login(params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let identifier = "Login API - POST"
        self.postRequest(identifier, url: self.loginURL, params: params, apiCompletion: apiCompletion)
        
    }
    
    func forgotPassword(params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let identifier = "Forgot PW API - POST"
        self.postRequest(identifier, url: self.forgotPasswordURL, params: params, apiCompletion: apiCompletion)
        
    }
    
}

extension ConnectionManager {
    
    private func printRequest(identifier: String, requestType: RequestType, requestURL: String, value: [String : AnyObject]) {
        print(identifier + " - " + requestType.rawValue + " - " + requestURL + " : ")
        print(value)
    }
    
    private func postRequest(identifier: String, url: String,  params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let paramsDict = dictionaryWithoutEmptyValues(params)
        
        self.printRequest(identifier,
                          requestType: RequestType.Request,
                          requestURL: url,
                          value: paramsDict)
        
        Alamofire
            .request(Method.POST, url, parameters: paramsDict, encoding: ParameterEncoding.JSON, headers: nil)
            .responseJSON { (response) in
                
                guard let value = response.result.value as? [String: AnyObject] else {
                    apiCompletion(responseValue: nil, error: "error_connection")
                    return
                }
                
                self.printRequest(identifier,
                    requestType: RequestType.Response,
                    requestURL: url,
                    value: value)
                
                if response.result.isSuccess {
                    if response.response?.statusCode == 200 {
                        
                        apiCompletion(responseValue: value, error: nil)
                        return
                        
                    }  else {
                        
                        if let errorDetail = value["code"] as? String {
                            apiCompletion(responseValue: value, error: errorDetail)
                        }  else {
                            apiCompletion(responseValue: value, error: "error_default")
                        }
                        return
                    }
                    
                } else   if response.result.isFailure {
                    
                    apiCompletion(responseValue: value, error: "error_connection")
                    
                    return
                }
        }
    }
}