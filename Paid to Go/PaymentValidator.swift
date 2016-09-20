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
enum PaymentValidationError: ErrorType {
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
    func parseJSONResponse(response: [String: AnyObject?]) -> (isValid: Bool?, error: ErrorType?)
}

struct IOSPlatformPaymentData: PlatformPaymentData {
    let platform = "apple"
    let productID: String
    let bundleID: String

    func getPaymentData(withToken token: String) -> [String : AnyObject] {
        return [
            "token": token,
            "platform": platform,
            "packageName": bundleID
        ]
    }
    
    func parseJSONResponse(response: [String: AnyObject?]) -> (isValid: Bool?, error: ErrorType?) {
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
            "token": token,
            "platform": platform,
            "packageName": packageName,
            "keyObject": keyObject
        ]
    }
    
    func parseJSONResponse(response: [String: AnyObject?]) -> (isValid: Bool?, error: ErrorType?) {
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
    func validatePayment(paymentToken paymentToken: String, withPlatformPaymentData platformPaymentData: PlatformPaymentData, callback: (isValid: Bool?, error: ErrorType?) -> Void) {
        let params = platformPaymentData.getPaymentData(withToken: paymentToken)
        
        Alamofire
            .request(.POST, url, parameters: params)
            .validate()
            .responseJSON { response in
                guard let value = response.result.value as? [String: AnyObject?] else {
                    callback(isValid: nil, error: PaymentValidationError.NoResponseValue)
                    return
                }
                
                // Do something with value JSON
                let parsedResponse = platformPaymentData.parseJSONResponse(value)
                
                callback(isValid: parsedResponse.isValid, error: parsedResponse.error)
            }
    }
}