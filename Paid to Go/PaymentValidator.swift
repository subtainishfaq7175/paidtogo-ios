//
//  PaymentValidator.swift
//  Doozie
//
//  Created by Fernando Ortiz on 19/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

import Alamofire

// MARK: - Error -
enum PaymentValidationError: Error {
    
    case ServerError
    case NoResponseValue
}


// MARK: - Platform specific data -
protocol PlatformPaymentData {
    /**
     Creates the dictionary to make the api call.
     
     - parameter token: The payment token
     
     - returns: the json dictionary to make the api call.
     */
    func getPaymentData(withToken token: String) -> [String: AnyObject]
    
    /**
     Parses api call response.
     
     - parameter response: API response
     
     - returns: A tuple containing if the response is a valid object and an optional error type.
     */
    func parseJSONResponse(response: [String: AnyObject?]) -> (isValid: Bool?, error: Error?)
}

struct IOSPlatformPaymentData: PlatformPaymentData {
    let platform = "apple"
    let productID: String
    let bundleID: String

    func getPaymentData(withToken token: String) -> [String : AnyObject] {
        return [
            "token": token as AnyObject,
            "platform": platform as AnyObject,
            "packageName": bundleID as AnyObject
        ]
    }
    
    func parseJSONResponse(response: [String: AnyObject?]) -> (isValid: Bool?, error: Error?) {
        return (isValid: true, error: nil)
    }
}

struct AndroidPlatformPaymentData: PlatformPaymentData {
    let platform = "google"
    let productID: String
    let packageName: String
    let keyObject: String
    
    func getPaymentData(withToken token: String) -> [String : AnyObject] {
        return [
            "token": token as AnyObject,
            "platform": platform as AnyObject,
            "packageName": packageName as AnyObject,
            "keyObject": keyObject as AnyObject
        ]
    }
    
    func parseJSONResponse(response: [String: AnyObject?]) -> (isValid: Bool?, error: Error?) {
        return (isValid: true, error: nil)
    }
}

// MARK: - Payment Validator struct -
struct PaymentValidator {
    let url: String
}


// MARK: - API Call -
extension PaymentValidator {
    
    /**
     Validates payment, making a call to a server hosting https://github.com/fmo91/iap_validation
     
     - parameter paymentToken:        The payment token
     - parameter platformPaymentData: A platformPaymentData struct
     - parameter callback:            The callback that handles the result
     */
    func validatePayment(paymentToken paymentToken: String, withPlatformPaymentData platformPaymentData: PlatformPaymentData, callback: @escaping (_ isValid: Bool?, _ error: Error?) -> Void) {
        let params = platformPaymentData.getPaymentData(withToken: paymentToken)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding(destination: .httpBody), headers: nil)
            .validate()
            .responseJSON { response in
                guard let value = response.result.value as? [String: AnyObject?] else {
                    callback(nil, PaymentValidationError.NoResponseValue)
                    return
                }
                
                // Do something with value JSON
                let parsedResponse = platformPaymentData.parseJSONResponse(response: value)
                
                callback(parsedResponse.isValid, parsedResponse.error)
            }
    }
}
