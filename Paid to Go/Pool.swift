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
    internal let kPoolEndDateTimeKey: String = "end_date_time"
    
    
    // MARK: Properties
    public var quantMembers: Int?
    public var earnedMoneyPerMile: String?
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
    public var endDateTime: String?
    
    
    
    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(_ map: Map){
        
    }
    
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        quantMembers <- map[kPoolQuantMembersKey]
        earnedMoneyPerMile <- map[kPoolEarnedMoneyPerMileKey]
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
        endDateTime <- map[kPoolEndDateTimeKey]
        
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        if quantMembers != nil {
            dictionary.updateValue(quantMembers!, forKey: kPoolQuantMembersKey)
        }
        if earnedMoneyPerMile != nil {
            dictionary.updateValue(earnedMoneyPerMile!, forKey: kPoolEarnedMoneyPerMileKey)
        }
        if poolType != nil {
            dictionary.updateValue(poolType!.dictionaryRepresentation(), forKey: kPoolPoolTypeKey)
        }
        if banner != nil {
            dictionary.updateValue(banner!, forKey: kPoolBannerKey)
        }
        if destinationLatitude != nil {
            dictionary.updateValue(destinationLatitude!, forKey: kPoolDestinationLatitudeKey)
        }
        if name != nil {
            dictionary.updateValue(name!, forKey: kPoolNameKey)
        }
        if moneyAvailable != nil {
            dictionary.updateValue(moneyAvailable!, forKey: kPoolMoneyAvailableKey)
        }
        if internalIdentifier != nil {
            dictionary.updateValue(internalIdentifier!, forKey: kPoolInternalIdentifierKey)
        }
        if iconPhoto != nil {
            dictionary.updateValue(iconPhoto!, forKey: kPoolIconPhotoKey)
        }
        if open != nil {
            dictionary.updateValue(open!, forKey: kPoolOpenKey)
        }
        if destinationLongitude != nil {
            dictionary.updateValue(destinationLongitude!, forKey: kPoolDestinationLongitudeKey)
        }
        if photoIconDescription != nil {
            dictionary.updateValue(photoIconDescription!, forKey: kPoolPhotoIconDescriptionKey)
        }
        if endDateTime != nil {
            dictionary.updateValue(endDateTime!, forKey: kPoolEndDateTimeKey)
        }
        
        return dictionary
}
}