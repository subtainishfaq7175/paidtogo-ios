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


class ConnectionManager {
    
    private var baseURL = "http://paid.xanthops.com/api/v1"
    
    private var registerURL: String { return "\(baseURL)/register" }
    private var loginURL: String { return "\(baseURL)/login" }
    private var forgotPasswordURL : String { return "\(baseURL)/recover_pass" }
    
    private var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: - Singleton
    static let sharedInstance = ConnectionManager()
    private init() {
    }
    
    private func printRequest(identifier: String, requestType: RequestType, requestURL: String, value: [String : AnyObject]) {
        print(identifier + " - " + requestType.rawValue + " - " + requestURL + " : ")
        print(value)
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
    
    private func request(identifier: String, url: String,  response: Response<AnyObject, NSError>, apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {

        guard let value = response.result.value as? [String: AnyObject] else {
            apiCompletion(responseValue: nil, error: "The request has failed")
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
                    apiCompletion(responseValue: value, error: "The request has failed")
                }
                return
            }
            
        } else   if response.result.isFailure {
            
            apiCompletion(responseValue: value, error: "Connection problem")
            
            return
        }
    }
    
    func register(params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let identifier = "Register API - POST"
        
        let paramsDict = dictionaryWithoutEmptyValues(params)
        
        self.printRequest(identifier,
                          requestType: RequestType.Response,
                          requestURL: registerURL,
                          value: paramsDict)
        
        Alamofire
            .request(Method.POST, registerURL, parameters: paramsDict, encoding: ParameterEncoding.JSON, headers: nil)
            .responseJSON { (response) in
                
                self.request(identifier, url: self.registerURL, response: response, apiCompletion: apiCompletion)
        }
    }
    
    func login(params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let identifier = "Login API - POST"
        
        let paramsDict = dictionaryWithoutEmptyValues(params)
        
        self.printRequest(identifier,
                          requestType: RequestType.Response,
                          requestURL: loginURL,
                          value: paramsDict)
        
        Alamofire
            .request(Method.POST, loginURL, parameters: paramsDict, encoding: ParameterEncoding.JSON, headers: nil)
            .responseJSON { (response) in
                
                self.request(identifier, url: self.loginURL, response: response, apiCompletion: apiCompletion)
        }
    }
    
    func forgotPassword(params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let identifier = "Forgot PW API - POST"
        
        let paramsDict = dictionaryWithoutEmptyValues(params)
        
        self.printRequest(identifier,
                          requestType: RequestType.Response,
                          requestURL: forgotPasswordURL,
                          value: paramsDict)
        
        Alamofire
            .request(Method.POST, forgotPasswordURL, parameters: paramsDict, encoding: ParameterEncoding.JSON, headers: nil)
            .responseJSON { (response) in
                
                self.request(identifier, url: self.forgotPasswordURL, response: response, apiCompletion: apiCompletion)
        }
    }
    
}