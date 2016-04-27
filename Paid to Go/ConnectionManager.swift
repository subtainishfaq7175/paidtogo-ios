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

enum RequestType: String {
    case Request    = "Request"     ;
    case Response   = "Response"    ;
}


class ConnectionManager {
    
    var baseURL = "http://paid.xanthops.com/api/v1"
    
    var registerURL: String { return "\(baseURL)/register" }
    
    //...
    
    private var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: - Singleton
    static let sharedInstance = ConnectionManager()
    private init() {
    }
    
    private func filterResponse () {
        
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
    
    func register(params: [String: AnyObject], apiCompletion: (responseValue: [String: AnyObject]?, error: String?) -> Void) {
        
        let identifier = "Register API - POST"
        
        self.printRequest(identifier, requestType: RequestType.Request, requestURL: registerURL, value: params)
        
        Alamofire
            .request(Method.POST, registerURL,
                parameters: dictionaryWithoutEmptyValues(params),
                encoding: ParameterEncoding.JSON,
                headers: nil)
            .responseJSON { (response) in
                guard let value = response.result.value as? [String: AnyObject] else {
                    return
                }
                
                self.printRequest(identifier, requestType: RequestType.Response, requestURL: self.registerURL, value: value)
                
                if response.result.isSuccess {
                    if response.response?.statusCode == 200 {
                       
                        apiCompletion(responseValue: value, error: nil)
                        return
                        
                    }  else {
                        
                        if let errorDetail = value["detail"] as? String {
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
    }
    
}