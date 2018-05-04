//
//  Receipt.swift
//
//  Created by Fernando Ortiz on 21/9/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

class Receipt: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kReceiptReceiptCreationDatePstKey: String = "receipt_creation_date_pst"
	internal let kReceiptVersionExternalIdentifierKey: String = "version_external_identifier"
	internal let kReceiptOriginalPurchaseDatePstKey: String = "original_purchase_date_pst"
	internal let kReceiptDownloadIdKey: String = "download_id"
	internal let kReceiptInAppKey: String = "in_app"
	internal let kReceiptRequestDatePstKey: String = "request_date_pst"
	internal let kReceiptReceiptTypeKey: String = "receipt_type"
	internal let kReceiptOriginalPurchaseDateKey: String = "original_purchase_date"
	internal let kReceiptAppItemIdKey: String = "app_item_id"
	internal let kReceiptOriginalApplicationVersionKey: String = "original_application_version"
	internal let kReceiptBundleIdKey: String = "bundle_id"
	internal let kReceiptRequestDateMsKey: String = "request_date_ms"
	internal let kReceiptAdamIdKey: String = "adam_id"
	internal let kReceiptReceiptCreationDateKey: String = "receipt_creation_date"
	internal let kReceiptRequestDateKey: String = "request_date"
	internal let kReceiptOriginalPurchaseDateMsKey: String = "original_purchase_date_ms"
	internal let kReceiptReceiptCreationDateMsKey: String = "receipt_creation_date_ms"
	internal let kReceiptApplicationVersionKey: String = "application_version"


    // MARK: Properties
	var receiptCreationDatePst: String?
	var versionExternalIdentifier: Int?
	var originalPurchaseDatePst: String?
	var downloadId: Int?
	var inApp: [InApp]?
	var requestDatePst: String?
	var receiptType: String?
	var originalPurchaseDate: String?
	var appItemId: Int?
	var originalApplicationVersion: String?
	var bundleId: String?
	var requestDateMs: String?
	var adamId: Int?
	var receiptCreationDate: String?
	var requestDate: String?
	var originalPurchaseDateMs: String?
	var receiptCreationDateMs: String?
	var applicationVersion: String?



    // MARK: ObjectMapper Initalizers
    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    required init?(map: Map){

    }

    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    func mapping(map: Map) {
		receiptCreationDatePst <- map[kReceiptReceiptCreationDatePstKey]
		versionExternalIdentifier <- map[kReceiptVersionExternalIdentifierKey]
		originalPurchaseDatePst <- map[kReceiptOriginalPurchaseDatePstKey]
		downloadId <- map[kReceiptDownloadIdKey]
		inApp <- map[kReceiptInAppKey]
		requestDatePst <- map[kReceiptRequestDatePstKey]
		receiptType <- map[kReceiptReceiptTypeKey]
		originalPurchaseDate <- map[kReceiptOriginalPurchaseDateKey]
		appItemId <- map[kReceiptAppItemIdKey]
		originalApplicationVersion <- map[kReceiptOriginalApplicationVersionKey]
		bundleId <- map[kReceiptBundleIdKey]
		requestDateMs <- map[kReceiptRequestDateMsKey]
		adamId <- map[kReceiptAdamIdKey]
		receiptCreationDate <- map[kReceiptReceiptCreationDateKey]
		requestDate <- map[kReceiptRequestDateKey]
		originalPurchaseDateMs <- map[kReceiptOriginalPurchaseDateMsKey]
		receiptCreationDateMs <- map[kReceiptReceiptCreationDateMsKey]
		applicationVersion <- map[kReceiptApplicationVersionKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if receiptCreationDatePst != nil {
            dictionary.updateValue(receiptCreationDatePst! as AnyObject, forKey: kReceiptReceiptCreationDatePstKey)
		}
		if versionExternalIdentifier != nil {
            dictionary.updateValue(versionExternalIdentifier! as AnyObject, forKey: kReceiptVersionExternalIdentifierKey)
		}
		if originalPurchaseDatePst != nil {
            dictionary.updateValue(originalPurchaseDatePst! as AnyObject, forKey: kReceiptOriginalPurchaseDatePstKey)
		}
		if downloadId != nil {
            dictionary.updateValue(downloadId! as AnyObject, forKey: kReceiptDownloadIdKey)
		}
		if (inApp?.count)! > 0 {
			var temp: [AnyObject] = []
			for item in inApp! {
                temp.append(item.dictionaryRepresentation() as AnyObject)
			}
            dictionary.updateValue(temp as AnyObject, forKey: kReceiptInAppKey)
		}
		if requestDatePst != nil {
            dictionary.updateValue(requestDatePst! as AnyObject, forKey: kReceiptRequestDatePstKey)
		}
		if receiptType != nil {
            dictionary.updateValue(receiptType! as AnyObject, forKey: kReceiptReceiptTypeKey)
		}
		if originalPurchaseDate != nil {
            dictionary.updateValue(originalPurchaseDate! as AnyObject, forKey: kReceiptOriginalPurchaseDateKey)
		}
		if appItemId != nil {
            dictionary.updateValue(appItemId! as AnyObject, forKey: kReceiptAppItemIdKey)
		}
		if originalApplicationVersion != nil {
            dictionary.updateValue(originalApplicationVersion! as AnyObject, forKey: kReceiptOriginalApplicationVersionKey)
		}
		if bundleId != nil {
            dictionary.updateValue(bundleId! as AnyObject, forKey: kReceiptBundleIdKey)
		}
		if requestDateMs != nil {
            dictionary.updateValue(requestDateMs! as AnyObject, forKey: kReceiptRequestDateMsKey)
		}
		if adamId != nil {
            dictionary.updateValue(adamId! as AnyObject, forKey: kReceiptAdamIdKey)
		}
		if receiptCreationDate != nil {
            dictionary.updateValue(receiptCreationDate! as AnyObject, forKey: kReceiptReceiptCreationDateKey)
		}
		if requestDate != nil {
            dictionary.updateValue(requestDate! as AnyObject, forKey: kReceiptRequestDateKey)
		}
		if originalPurchaseDateMs != nil {
            dictionary.updateValue(originalPurchaseDateMs! as AnyObject, forKey: kReceiptOriginalPurchaseDateMsKey)
		}
		if receiptCreationDateMs != nil {
            dictionary.updateValue(receiptCreationDateMs! as AnyObject, forKey: kReceiptReceiptCreationDateMsKey)
		}
		if applicationVersion != nil {
            dictionary.updateValue(applicationVersion! as AnyObject, forKey: kReceiptApplicationVersionKey)
		}

        return dictionary
    }

}
