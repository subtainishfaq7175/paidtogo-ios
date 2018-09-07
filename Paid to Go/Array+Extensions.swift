//
//  Array+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 27/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import Alamofire

private let arrayParametersKey = "arrayParametersKey"

//extension RangeReplaceableCollectionType where Generator.Element : Equatable {
//    
//    // Remove first collection element that is equal to the given `object`:
//    mutating func removeObject(object : Generator.Element) {
//        if let index = self.indexOf(object) {
//            self.removeAtIndex(index)
//        }
//    }
//}

// Extension for Swift 3
//extension Array where Element: Equatable {
//    
//    // Remove first collection element that is equal to the given `object`:
//    mutating func removeObject(object: Element) {
//        if let index = index(of: object) {
//            remove(at: index)
//        }
//    }
//}

/// Extenstion that allows an array be sent as a request parameters
extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}


/// Convert the parameters into a json array, and it is added as the request body.
/// The array must be sent as parameters using its `asParameters` method.
public struct ArrayEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters,
            let array = parameters[arrayParametersKey] else {
                return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}
