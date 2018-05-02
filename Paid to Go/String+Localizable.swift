
//
//  String+Localizable.swift
//  Celebrastic
//
//  Created by Fernando Ortiz on 1/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

extension String {
    func localize() -> String {
        return String(key: self)
    }
    
    
    /**
     Inits with localized string key
     
     - parameter key: the localized string key
     
     - returns: a localized string using the key provided as param
     */
    
    init(key: String) {
        self = NSLocalizedString(key, comment: "")
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
}
