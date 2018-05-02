//
//  ReceiptValidationResult.swift
//
//  Created by Fernando Ortiz on 21/9/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

class ReceiptValidationResult: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kReceiptValidationResultReceiptKey: String = "receipt"
	internal let kReceiptValidationResultLatestReceiptInfoKey: String = "latest_receipt_info"
	internal let kReceiptValidationResultStatusKey: String = "status"
	internal let kReceiptValidationResultEnvironmentKey: String = "environment"
	internal let kReceiptValidationResultLatestReceiptKey: String = "latest_receipt"


    // MARK: Properties
	var receipt: Receipt?
//	var latestReceiptInfo: [LatestReceiptInfo]?
    var latestReceiptInfo: [Receipt]?
	var status: Int?
	var environment: String?
	var latestReceipt: String?



    // MARK: ObjectMapper Initalizers
    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    required init?(map: Map){
        let json = map.JSON
        guard let _ = json["receipt"] as? [String: AnyObject] else {
            return nil
        }
    }

    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    func mapping(map: Map) {
		receipt <- map[kReceiptValidationResultReceiptKey]
		latestReceiptInfo <- map[kReceiptValidationResultLatestReceiptInfoKey]
		status <- map[kReceiptValidationResultStatusKey]
		environment <- map[kReceiptValidationResultEnvironmentKey]
		latestReceipt <- map[kReceiptValidationResultLatestReceiptKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if receipt != nil {
            dictionary.updateValue(receipt!.dictionaryRepresentation() as AnyObject, forKey: kReceiptValidationResultReceiptKey)
		}
		if (latestReceiptInfo?.count)! > 0 {
			var temp: [AnyObject] = []
			for item in latestReceiptInfo! {
                temp.append(item.dictionaryRepresentation() as AnyObject)
			}
            dictionary.updateValue(temp as AnyObject, forKey: kReceiptValidationResultLatestReceiptInfoKey)
		}
		if status != nil {
            dictionary.updateValue(status! as AnyObject, forKey: kReceiptValidationResultStatusKey)
		}
		if environment != nil {
            dictionary.updateValue(environment! as AnyObject, forKey: kReceiptValidationResultEnvironmentKey)
		}
		if latestReceipt != nil {
            dictionary.updateValue(latestReceipt! as AnyObject, forKey: kReceiptValidationResultLatestReceiptKey)
		}

        return dictionary
    }

}

// MARK: - UTILS -
extension ReceiptValidationResult {
    
    func isValid() -> Bool {
        
        guard let receipt = receipt else {
            return false
        }

        guard let inApps = receipt.inApp else {
            return false
        }
        
        for info in inApps {
            if let expiresDateString = info.expiresDate {
                let expiresDateStringComponents = expiresDateString.components(separatedBy: " ")
                var expiresDateStringFormatted = ""
                
                for component in expiresDateStringComponents {
                    if component == expiresDateStringComponents.last {
                        break
                    }
                    if component != expiresDateStringComponents.first {
                        expiresDateStringFormatted.append(" ")
                    }
                    
                    expiresDateStringFormatted.append(component)
                }
                
                let expiresDate = NSDate.getDateWithFormatddMMyyyy(dateString: expiresDateStringFormatted)
                
                if !expiresDate.isDatePreviousToCurrentDate() {
                    return true
                }

            }
        }
        
        return false
    }

}
