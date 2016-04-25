//
//  ConnectionManager.swift
//  Paid to Go
//
//  Created by MacbookPro on 22/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import Alamofire


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
    
    func register(params: [String: AnyObject], completion: (user: User?, error: String?) -> Void) {
        
//        let params = [
//            "name": name,
//            "username": username,
//            "password": password
//        ]
        
        Alamofire
            .request(Method.POST, registerURL,
                parameters: dictionaryWithoutEmptyValues(params),
                encoding: ParameterEncoding.JSON,
                headers: nil
            )
            .responseJSON { (response) in
                guard let value = response.result.value as? [String: AnyObject] else {
                    return
                }
                
                if response.result.isFailure {
                    // algo
                }
                
                if let code = value["code"] as? String where code == "USER_EXISTS" {
                    completion(user: nil, error: code)
                }
                
                
            }
    }
    
}