//
//  DefaultNotification.swifts
//  Paid to Go
//
//  Created by MacbookPro on 29/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper

public class Pool: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kPoolQuantMembersKey: String = "quant_members"
    internal let kPoolEarnedMoneyPerMileKey: String = "earned_money_per_mile"
    internal let kPoolPoolTypeKey: String = "pool_type"
    internal let kPoolBannerKey: String = "banner"
    internal let kPoolDestinationLatitudeKey: String = "destination_latitude"
    internal let kPoolNameKey: String = "name"
    internal let kPoolMoneyAvailableKey: String = "money_available"
    internal let kPoolInternalIdentifierKey: String = "id"
    internal let kPoolIconPhotoKey: String = "icon_photo"
    internal let kPoolOpenKey: String = "open"
    internal let kPoolDestinationLongitudeKey: String = "destination_longitude"
    internal let kPoolPhotoIconDescriptionKey: String = "photo_icon_description"
    internal let kPoolStartDateKey: String = "start_date"
    internal let kPoolEndDateTimeKey: String = "end_date_time"
    internal let kPoolLimitPerDayKey: String = "limit_per_day"
    internal let kPoolLimitPerMonthKey: String = "limit_per_month"
    internal let kPoolSponsorLinkKey: String = "link"
    internal let kTermsAndConditionsKey: String = "terms_and_condition"
    internal let kCountryKey: String = "country"

    
    
    // MARK: Properties
    public var quantMembers: Int?
    public var earnedMoneyPerMile: Double?
    public var poolType: PoolType?
    public var banner: String?
    public var destinationLatitude: String?
    public var name: String?
    public var moneyAvailable: String?
    public var internalIdentifier: String?
    public var iconPhoto: String?
    public var open: String?
    public var destinationLongitude: String?
    public var photoIconDescription: String?
    public var startDateTime: String?
    public var endDateTime: String?
    public var limitPerDay: String?
    public var limitPerMonth: String?
    public var sponsorLink: String?
    public var termsAndConditions: String?
    public var country: String?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map){
        
    }
    
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        quantMembers <- map[kPoolQuantMembersKey]
        var earnedMoney = ""
        earnedMoney <- map[kPoolEarnedMoneyPerMileKey]
        earnedMoneyPerMile = Double(earnedMoney)
        poolType <- map[kPoolPoolTypeKey]
        banner <- map[kPoolBannerKey]
        destinationLatitude <- map[kPoolDestinationLatitudeKey]
        name <- map[kPoolNameKey]
        moneyAvailable <- map[kPoolMoneyAvailableKey]
        internalIdentifier <- map[kPoolInternalIdentifierKey]
        iconPhoto <- map[kPoolIconPhotoKey]
        open <- map[kPoolOpenKey]
        destinationLongitude <- map[kPoolDestinationLongitudeKey]
        photoIconDescription <- map[kPoolPhotoIconDescriptionKey]
        startDateTime <- map[kPoolStartDateKey]
        endDateTime <- map[kPoolEndDateTimeKey]
        limitPerDay <- map[kPoolLimitPerDayKey]
        limitPerMonth <- map[kPoolLimitPerMonthKey]
        sponsorLink <- map[kPoolSponsorLinkKey]
        termsAndConditions <- map[kTermsAndConditionsKey]
        country <- map[kCountryKey]

    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
        if quantMembers != nil {
            dictionary.updateValue(quantMembers! as AnyObject, forKey: kPoolQuantMembersKey)
        }
        if earnedMoneyPerMile != nil {
            dictionary.updateValue(earnedMoneyPerMile! as AnyObject, forKey: kPoolEarnedMoneyPerMileKey)
        }
        if poolType != nil {
            dictionary.updateValue(poolType!.dictionaryRepresentation() as AnyObject, forKey: kPoolPoolTypeKey)
        }
        if banner != nil {
            dictionary.updateValue(banner! as AnyObject, forKey: kPoolBannerKey)
        }
        if destinationLatitude != nil {
            dictionary.updateValue(destinationLatitude! as AnyObject, forKey: kPoolDestinationLatitudeKey)
        }
        if name != nil {
            dictionary.updateValue(name! as AnyObject, forKey: kPoolNameKey)
        }
        if moneyAvailable != nil {
            dictionary.updateValue(moneyAvailable! as AnyObject, forKey: kPoolMoneyAvailableKey)
        }
        if internalIdentifier != nil {
            dictionary.updateValue(internalIdentifier! as AnyObject, forKey: kPoolInternalIdentifierKey)
        }
        if iconPhoto != nil {
            dictionary.updateValue(iconPhoto! as AnyObject, forKey: kPoolIconPhotoKey)
        }
        if open != nil {
            dictionary.updateValue(open! as AnyObject, forKey: kPoolOpenKey)
        }
        if destinationLongitude != nil {
            dictionary.updateValue(destinationLongitude! as AnyObject, forKey: kPoolDestinationLongitudeKey)
        }
        if photoIconDescription != nil {
            dictionary.updateValue(photoIconDescription! as AnyObject, forKey: kPoolPhotoIconDescriptionKey)
        }
        if endDateTime != nil {
            dictionary.updateValue(endDateTime! as AnyObject, forKey: kPoolEndDateTimeKey)
        }
        if country != nil {
            dictionary.updateValue(country! as AnyObject, forKey: kCountryKey)
        }
        return dictionary
    }
}
