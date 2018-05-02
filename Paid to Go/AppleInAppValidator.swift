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
//    static func getReceiptData() -> String? {
//        var receiptDataBase64: String?// = transactionIdentifier
//        
//        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
//            let receiptData = NSData(contentsOf: appStoreReceiptURL) {
//            
//            receiptDataBase64 = receiptData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength).stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("\r", withString: "")
//        }
//        
//        return receiptDataBase64
//    }
    
//    func verifyReceipt(receiptData: String, completionHandler: @escaping (result: ReceiptValidationResult?, _ error: String?) -> Void) {
//
//        // Common errors when encoding to base64
//        let receipt = receiptData.replacingOccurrences(of:"\n" , with: "").replacingOccurrences(of: "\r", with: "")
////            .stringByReplacingOccurrencesOfString("\n", withString: "")
////            .stringByReplacingOccurrencesOfString("\r", withString: "")
//
//        let params = [
//            "password": sharedSecret,
//            "receipt-data": receipt
//        ]
//
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        let request = NSMutableURLRequest(url: NSURL(string: validationURL)! as URL)
//        request.httpMethod = "POST"
//        let data = try? JSONSerialization.data(withJSONObject: params, options: [])
//        request.httpBody = data
//
//        let task = session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
//
//            if let error = error {
//                completionHandler(nil, error.localizedDescription)
//                return
//            }
//            guard let data = data else {
//                completionHandler(nil, error?.localizedDescription)
//                return
//            }
//
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
//                completionHandler(nil, error?.localizedDescription)
//                return
//            }
//
//            guard let receiptValidationResult = Mapper<ReceiptValidationResult>().map(json) else {
//                completionHandler(nil, error?.localizedDescription)
//                return
//            }
//
//            completionHandler(result: receiptValidationResult, error: nil)
//            } as! (Data?, URLResponse?, Error?) -> Void as! (Data?, URLResponse?, Error?) -> Void as! (Data?, URLResponse?, Error?) -> Void
//        task.()
//
//    }
}
