//
//  InApp.swift
//
//  Created by Fernando Ortiz on 21/9/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

class InApp: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kInAppExpiresDateMsKey: String = "expires_date_ms"
	internal let kInAppPurchaseDatePstKey: String = "purchase_date_pst"
	internal let kInAppPurchaseDateMsKey: String = "purchase_date_ms"
	internal let kInAppWebOrderLineItemIdKey: String = "web_order_line_item_id"
	internal let kInAppExpiresDatePstKey: String = "expires_date_pst"
	internal let kInAppIsTrialPeriodKey: String = "is_trial_period"
	internal let kInAppTransactionIdKey: String = "transaction_id"
	internal let kInAppProductIdKey: String = "product_id"
	internal let kInAppPurchaseDateKey: String = "purchase_date"
	internal let kInAppExpiresDateKey: String = "expires_date"
	internal let kInAppOriginalPurchaseDateKey: String = "original_purchase_date"
	internal let kInAppOriginalTransactionIdKey: String = "original_transaction_id"
	internal let kInAppQuantityKey: String = "quantity"
	internal let kInAppOriginalPurchaseDateMsKey: String = "original_purchase_date_ms"
	internal let kInAppOriginalPurchaseDatePstKey: String = "original_purchase_date_pst"


    // MARK: Properties
	var expiresDateMs: String?
	var purchaseDatePst: String?
	var purchaseDateMs: String?
	var webOrderLineItemId: String?
	var expiresDatePst: String?
	var isTrialPeriod: String?
	var transactionId: String?
	var productId: String?
	var purchaseDate: String?
	var expiresDate: String?
	var originalPurchaseDate: String?
	var originalTransactionId: String?
	var quantity: String?
	var originalPurchaseDateMs: String?
	var originalPurchaseDatePst: String?



    // MARK: ObjectMapper Initalizers
    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    required init?(_ map: Map){

    }

    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    func mapping(map: Map) {
		expiresDateMs <- map[kInAppExpiresDateMsKey]
		purchaseDatePst <- map[kInAppPurchaseDatePstKey]
		purchaseDateMs <- map[kInAppPurchaseDateMsKey]
		webOrderLineItemId <- map[kInAppWebOrderLineItemIdKey]
		expiresDatePst <- map[kInAppExpiresDatePstKey]
		isTrialPeriod <- map[kInAppIsTrialPeriodKey]
		transactionId <- map[kInAppTransactionIdKey]
		productId <- map[kInAppProductIdKey]
		purchaseDate <- map[kInAppPurchaseDateKey]
		expiresDate <- map[kInAppExpiresDateKey]
		originalPurchaseDate <- map[kInAppOriginalPurchaseDateKey]
		originalTransactionId <- map[kInAppOriginalTransactionIdKey]
		quantity <- map[kInAppQuantityKey]
		originalPurchaseDateMs <- map[kInAppOriginalPurchaseDateMsKey]
		originalPurchaseDatePst <- map[kInAppOriginalPurchaseDatePstKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if expiresDateMs != nil {
			dictionary.updateValue(expiresDateMs!, forKey: kInAppExpiresDateMsKey)
		}
		if purchaseDatePst != nil {
			dictionary.updateValue(purchaseDatePst!, forKey: kInAppPurchaseDatePstKey)
		}
		if purchaseDateMs != nil {
			dictionary.updateValue(purchaseDateMs!, forKey: kInAppPurchaseDateMsKey)
		}
		if webOrderLineItemId != nil {
			dictionary.updateValue(webOrderLineItemId!, forKey: kInAppWebOrderLineItemIdKey)
		}
		if expiresDatePst != nil {
			dictionary.updateValue(expiresDatePst!, forKey: kInAppExpiresDatePstKey)
		}
		if isTrialPeriod != nil {
			dictionary.updateValue(isTrialPeriod!, forKey: kInAppIsTrialPeriodKey)
		}
		if transactionId != nil {
			dictionary.updateValue(transactionId!, forKey: kInAppTransactionIdKey)
		}
		if productId != nil {
			dictionary.updateValue(productId!, forKey: kInAppProductIdKey)
		}
		if purchaseDate != nil {
			dictionary.updateValue(purchaseDate!, forKey: kInAppPurchaseDateKey)
		}
		if expiresDate != nil {
			dictionary.updateValue(expiresDate!, forKey: kInAppExpiresDateKey)
		}
		if originalPurchaseDate != nil {
			dictionary.updateValue(originalPurchaseDate!, forKey: kInAppOriginalPurchaseDateKey)
		}
		if originalTransactionId != nil {
			dictionary.updateValue(originalTransactionId!, forKey: kInAppOriginalTransactionIdKey)
		}
		if quantity != nil {
			dictionary.updateValue(quantity!, forKey: kInAppQuantityKey)
		}
		if originalPurchaseDateMs != nil {
			dictionary.updateValue(originalPurchaseDateMs!, forKey: kInAppOriginalPurchaseDateMsKey)
		}
		if originalPurchaseDatePst != nil {
			dictionary.updateValue(originalPurchaseDatePst!, forKey: kInAppOriginalPurchaseDatePstKey)
		}

        return dictionary
    }

}