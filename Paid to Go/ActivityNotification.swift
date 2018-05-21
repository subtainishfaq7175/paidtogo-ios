//
//  ActivityNotification.swift
//
//  Created by German campagno on 27/5/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class ActivityNotification: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kActivityNotificationSavedCo2Key: String = "saved_co2"
    internal let kActivityNotificationSavedCaloriesKey: String = "saved_calories"
	internal let kActivityNotificationIconPhotoKey: String = "icon_photo"
	internal let kActivityNotificationMilesTraveledKey: String = "miles_traveled"
	internal let kActivityNotificationOpenKey: String = "open"
	internal let kActivityNotificationPoolIdKey: String = "pool_id"
	internal let kActivityNotificationStartDateTimeKey: String = "start_date_time"
	internal let kActivityNotificationSavedGasKey: String = "saved_gas"
	internal let kActivityNotificationIconPhotoDescriptionKey: String = "icon_photo_description"
	internal let kActivityNotificationEndDateTimeKey: String = "end_date_time"
	internal let kActivityNotificationEarnedMoneyKey: String = "earned_money"
	internal let kActivityNotificationUserKey: String = "user"
	internal let kActivityNotificationNameKey: String = "name"
    internal let kActivityNotificationInternalIdentifierKey : String = "activity_id"
    internal let kActivityNotificationPoolKey : String = "pool"
    internal let kActivityNotificationCodeKey : String = "code"

    // MARK: Properties
	public var savedCo2: String?
    public var savedCalories: String?
	public var iconPhoto: String?
	public var milesTraveled: String?
	public var open: String?
	public var poolId: String?
	public var startDateTime: String?
	public var savedGas: String?
	public var iconPhotoDescription: String?
	public var endDateTime: String?
	public var earnedMoney: String?
	 var user: User?
	public var name: String?
    public var internalIdentifier: String?
    public var pool: Pool?
    public var code: Int?

    // MARK: ObjectMapper Initalizers
    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    public required init?(map: Map){

    }

    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
   public func mapping(map: Map) {
		savedCo2 <- map[kActivityNotificationSavedCo2Key]
        savedCalories <- map[kActivityNotificationSavedCaloriesKey]
		iconPhoto <- map[kActivityNotificationIconPhotoKey]
		milesTraveled <- map[kActivityNotificationMilesTraveledKey]
		open <- map[kActivityNotificationOpenKey]
		poolId <- map[kActivityNotificationPoolIdKey]
		startDateTime <- map[kActivityNotificationStartDateTimeKey]
		savedGas <- map[kActivityNotificationSavedGasKey]
		iconPhotoDescription <- map[kActivityNotificationIconPhotoDescriptionKey]
		endDateTime <- map[kActivityNotificationEndDateTimeKey]
		earnedMoney <- map[kActivityNotificationEarnedMoneyKey]
		user <- map[kActivityNotificationUserKey]
		name <- map[kActivityNotificationNameKey]
        internalIdentifier <- map[kActivityNotificationInternalIdentifierKey]
        pool <- map[kActivityNotificationPoolKey]
        code <- map[kActivityNotificationCodeKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if savedCo2 != nil {
            dictionary.updateValue(savedCo2! as AnyObject, forKey: kActivityNotificationSavedCo2Key)
		}
		if iconPhoto != nil {
            dictionary.updateValue(iconPhoto! as AnyObject, forKey: kActivityNotificationIconPhotoKey)
		}
		if milesTraveled != nil {
            dictionary.updateValue(milesTraveled! as AnyObject, forKey: kActivityNotificationMilesTraveledKey)
		}
		if open != nil {
            dictionary.updateValue(open! as AnyObject, forKey: kActivityNotificationOpenKey)
		}
		if poolId != nil {
            dictionary.updateValue(poolId! as AnyObject, forKey: kActivityNotificationPoolIdKey)
		}
		if startDateTime != nil {
            dictionary.updateValue(startDateTime! as AnyObject, forKey: kActivityNotificationStartDateTimeKey)
		}
		if savedGas != nil {
            dictionary.updateValue(savedGas! as AnyObject, forKey: kActivityNotificationSavedGasKey)
		}
		if iconPhotoDescription != nil {
            dictionary.updateValue(iconPhotoDescription! as AnyObject, forKey: kActivityNotificationIconPhotoDescriptionKey)
		}
		if endDateTime != nil {
            dictionary.updateValue(endDateTime! as AnyObject, forKey: kActivityNotificationEndDateTimeKey)
		}
		if earnedMoney != nil {
            dictionary.updateValue(earnedMoney! as AnyObject, forKey: kActivityNotificationEarnedMoneyKey)
		}
		if user != nil {
			dictionary.updateValue(user!, forKey: kActivityNotificationUserKey)
		}
		if name != nil {
            dictionary.updateValue(name! as AnyObject, forKey: kActivityNotificationNameKey)
		}
        if pool != nil {
            dictionary.updateValue(pool! as AnyObject, forKey: kActivityNotificationPoolKey)
        }

        return dictionary
    }

}
