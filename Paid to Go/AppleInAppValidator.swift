//
//  AppleInAppValidator.swift
//  Doozie
//
//  Created by Fernando Ortiz on 21/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

/*
enum AppleInAppValidatorError: ErrorType {
    case EmptyResponse
    case CouldNotParseJSON
    case Unknown
}
*/

final class AppleInAppValidator {
    
    private var sharedSecret: String = "ca2512d3780e42c8a56e7d9b3fb39835"
    
//    #if DEBUG
    private let validationURL = "https://sandbox.itunes.apple.com/verifyReceipt"
//    #else
//    private let validationURL = "https://buy.itunes.apple.com/verifyReceipt"
//    #endif
    
    // MARK: - Singleton
    private init() {}
    static let sharedInstance = AppleInAppValidator()
    
    // MARK: - Configuration 
    func setSharedSecret(sharedSecret: String) {
        self.sharedSecret = sharedSecret
    }
    
    // MARK: - Utils -
    static func getReceiptData() -> String? {
        var receiptDataBase64: String?// = transactionIdentifier
        
        if let appStoreReceiptURL = NSBundle.mainBundle().appStoreReceiptURL,
            let receiptData = NSData(contentsOfURL: appStoreReceiptURL) {
            
            receiptDataBase64 = receiptData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength).stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("\r", withString: "")
        }
        
        return receiptDataBase64
    }
    
    func verifyReceipt(receiptData: String, completionHandler: (result: ReceiptValidationResult?, error: String?) -> Void) {
        
        // Common errors when encoding to base64
        let receipt = receiptData
            .stringByReplacingOccurrencesOfString("\n", withString: "")
            .stringByReplacingOccurrencesOfString("\r", withString: "")
        
        let params = [
            "password": sharedSecret,
            "receipt-data": receipt
        ]
                
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSMutableURLRequest(URL: NSURL(string: validationURL)!)
        request.HTTPMethod = "POST"
        let data = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.HTTPBody = data
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let error = error {
                completionHandler(result: nil, error: error.description)
                return
            }
            guard let data = data else {
                completionHandler(result: nil, error: error?.description)
                return
            }
            
            guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) else {
                completionHandler(result: nil, error: error?.description)
                return
            }
            
            guard let receiptValidationResult = Mapper<ReceiptValidationResult>().map(json) else {
                completionHandler(result: nil, error: error?.description)
                return
            }
            
            completionHandler(result: receiptValidationResult, error: nil)
        }
        task.resume()
        
    }
}
