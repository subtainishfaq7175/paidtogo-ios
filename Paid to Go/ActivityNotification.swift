//
//  ActivityNotification.swift
//
//  Created by German campagno on 27/5/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper
// start_longitude,  , ,
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
    internal let kActivityNotificationStepsKey : String = "sum_of_step"
    
//    New fields
    internal let kActivityNotificationStartLongKey : String = "start_longitude"
    internal let kActivityNotificationStartLatKey : String = "start_latitude"
    internal let kActivityNotificationUserIDKey : String = "user_id"
    internal let kActivityNotificationPhotoKey : String = "photo"
    internal let kActivityNotificationEndLatKey : String = "end_latitude"
    internal let kActivityNotificationEndLongKey : String = "end_longitude"
    
    internal let kActivityNotificationStepCountKey : String = "total_steps"
    internal let kActivityNotificationActivityTypeKey : String = "activity_type"
    internal let kActivityNotificationSaveTrafficKey: String = "save_traffic"
    internal let kActivityNotificationSavedTrafficKey: String = "saved_traffic"
    
    internal let kActivityNotificationEarnedPointsKey: String = "earned_points"
    
    // MARK: Properties
	public var savedCo2: Double = 0
    public var savedCalories: Double = 0
	public var iconPhoto: String?
	public var milesTraveled: Double = 0
	public var open: String?
	public var poolId: String?
	public var startDateTime: String?
	public var savedGas: Double = 0
	public var iconPhotoDescription: String?
	public var endDateTime: String?
	public var earnedMoney: Double = 0
	 var user: User?
	public var name: String?
    public var internalIdentifier: String?
    public var SumOfStep: Int = 0

    public var pool: Pool?
    public var code: Int?
    
    public var startLongitude: Double?
    public var startLatitude: Double?
    public var endLongitude: Double?
    public var endLatitude: Double?
    public var userId: Int?
    public var photo: String?

    public var activityType: Int?
    public var totalSteps: Int = 0
    
    public var savedTraffic: Double = 0
    public var earnedPoints: Double = 0
    
    public var bikeMiles: Double?
    public var walkMiles: Double?
    public var gymCheckIns: Int?
    
    // MARK: ObjectMapper Initalizers
    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    public required init?(map: Map){

    }
    
    public init() {

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
		savedGas <- map[kActivityNotificationSaveTrafficKey]
		iconPhotoDescription <- map[kActivityNotificationIconPhotoDescriptionKey]
		endDateTime <- map[kActivityNotificationEndDateTimeKey]
		earnedMoney <- map[kActivityNotificationEarnedMoneyKey]
		user <- map[kActivityNotificationUserKey]
		name <- map[kActivityNotificationNameKey]
        internalIdentifier <- map[kActivityNotificationInternalIdentifierKey]
        pool <- map[kActivityNotificationPoolKey]
        code <- map[kActivityNotificationCodeKey]
        SumOfStep <- map[kActivityNotificationStepsKey]
    
    startLongitude <- map[kActivityNotificationStartLongKey]
    startLatitude <- map[kActivityNotificationStartLongKey]
    endLongitude <- map[kActivityNotificationEndLongKey]
    endLatitude <- map[kActivityNotificationEndLatKey]
    userId <- map[kActivityNotificationUserIDKey]
    photo <- map[kActivityNotificationPhotoKey]
    activityType <- map[kActivityNotificationActivityTypeKey]
    totalSteps <- map[kActivityNotificationStepCountKey]
    
    savedTraffic <- map[kActivityNotificationSaveTrafficKey]
    
    if map[kActivityNotificationSaveTrafficKey].currentKey == nil {
        savedTraffic <- map[kActivityNotificationSavedTrafficKey]
    }
    
    earnedPoints <- map[kActivityNotificationEarnedPointsKey]
    
    savedTraffic.roundToTwoDecinalPlace()
    earnedPoints.roundToTwoDecinalPlace()
    earnedMoney.roundToTwoDecinalPlace()
    savedGas.roundToTwoDecinalPlace()
    milesTraveled.roundToTwoDecinalPlace()
    savedCo2.roundToTwoDecinalPlace()
    savedCalories.roundToTwoDecinalPlace()
    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
        dictionary.updateValue(savedCo2 as AnyObject, forKey: kActivityNotificationSavedCo2Key)
	
		if iconPhoto != nil {
            dictionary.updateValue(iconPhoto! as AnyObject, forKey: kActivityNotificationIconPhotoKey)
		}
	
        dictionary.updateValue(milesTraveled as AnyObject, forKey: kActivityNotificationMilesTraveledKey)
		
		if open != nil {
            dictionary.updateValue(open! as AnyObject, forKey: kActivityNotificationOpenKey)
		}
		if poolId != nil {
            dictionary.updateValue(poolId! as AnyObject, forKey: kActivityNotificationPoolIdKey)
		}
		if startDateTime != nil {
            dictionary.updateValue(startDateTime! as AnyObject, forKey: kActivityNotificationStartDateTimeKey)
		}
		
        
        dictionary.updateValue(savedGas as AnyObject, forKey: kActivityNotificationSavedGasKey)
		
		if iconPhotoDescription != nil {
            dictionary.updateValue(iconPhotoDescription! as AnyObject, forKey: kActivityNotificationIconPhotoDescriptionKey)
		}
		if endDateTime != nil {
            dictionary.updateValue(endDateTime! as AnyObject, forKey: kActivityNotificationEndDateTimeKey)
		}
		
        
        dictionary.updateValue(earnedMoney as AnyObject, forKey: kActivityNotificationEarnedMoneyKey)
		
		if user != nil {
			dictionary.updateValue(user!, forKey: kActivityNotificationUserKey)
		}
		if name != nil {
            dictionary.updateValue(name! as AnyObject, forKey: kActivityNotificationNameKey)
		}
        if pool != nil {
            dictionary.updateValue(pool! as AnyObject, forKey: kActivityNotificationPoolKey)
        }
     
        dictionary.updateValue(SumOfStep as AnyObject, forKey: kActivityNotificationStepsKey)
        
        
        if let startLatitude = startLatitude {
            dictionary.updateValue(startLatitude as AnyObject, forKey: kActivityNotificationStartLongKey)
        }
        if let startLongitude = startLongitude {
            dictionary.updateValue(startLongitude as AnyObject, forKey: kActivityNotificationStartLongKey)
        }
        if let endLatitude = endLatitude {
            dictionary.updateValue(endLatitude  as AnyObject, forKey: kActivityNotificationEndLatKey)
        }
        if let endLongitude = endLongitude {
            dictionary.updateValue(endLongitude as AnyObject, forKey: kActivityNotificationEndLongKey)
        }
        if let userId = userId {
            dictionary.updateValue(userId as AnyObject, forKey: kActivityNotificationUserIDKey)
        }
        if let photo = photo {
            dictionary.updateValue(photo as AnyObject, forKey: kActivityNotificationPhotoKey)
        }
        if let activityType = activityType {
            dictionary.updateValue(activityType as AnyObject, forKey: kActivityNotificationActivityTypeKey)
        }
        
        dictionary.updateValue(totalSteps as AnyObject, forKey: kActivityNotificationStepsKey)
        

        return dictionary
    }

}
