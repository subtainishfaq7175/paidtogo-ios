//
//  PoolType.swift
//
//  Created by Germán Campagno on 13/5/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class PoolType: NSObject, Mappable, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kPoolTypeDetailKey: String = "detail"
    internal let kPoolTypeBackgroundPictureKey: String = "background_picture"
    internal let kPoolTypeInternalIdentifierKey: String = "id"
    internal let kPoolTypeColorKey: String = "color"
    internal let kPoolTypeMaxSpeedKey: String = "max_speed"
    internal let kPoolTypeMinSpeedKey: String = "min_speed"
    internal let kPoolTypeCodeKey: String = "code"
    internal let kPoolTypeGpsTrackingRequiredKey: String = "gps_tracking_required"
    internal let kPoolTypePhotoVerificationRequiredKey: String = "photo_verification_required"
    internal let kPoolTypeNameKey: String = "name"
    
    
    // MARK: Properties
    public var detail: String?
    public var backgroundPicture: String?
    public var internalIdentifier: String?
    public var color: String?
    public var maxSpeed: String?
    public var minSpeed: String?
    public var code: String?
    public var gpsTrackingRequired: String?
    public var photoVerificationRequired: String?
    public var name: String?
    
    
    
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
        detail <- map[kPoolTypeDetailKey]
        backgroundPicture <- map[kPoolTypeBackgroundPictureKey]
        internalIdentifier <- map[kPoolTypeInternalIdentifierKey]
        color <- map[kPoolTypeColorKey]
        maxSpeed <- map[kPoolTypeMaxSpeedKey]
        minSpeed <- map[kPoolTypeMinSpeedKey]
        code <- map[kPoolTypeCodeKey]
        gpsTrackingRequired <- map[kPoolTypeGpsTrackingRequiredKey]
        photoVerificationRequired <- map[kPoolTypePhotoVerificationRequiredKey]
        name <- map[kPoolTypeNameKey]
        
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
//        if detail != nil {
//            dictionary.updateValue(detail!, forKey: kPoolTypeDetailKey)
//        }
//        if backgroundPicture != nil {
//            dictionary.updateValue(backgroundPicture!, forKey: kPoolTypeBackgroundPictureKey)
//        }
//        if internalIdentifier != nil {
//            dictionary.updateValue(internalIdentifier!, forKey: kPoolTypeInternalIdentifierKey)
//        }
//        if color != nil {
//            dictionary.updateValue(color!, forKey: kPoolTypeColorKey)
//        }
//        if maxSpeed != nil {
//            dictionary.updateValue(maxSpeed!, forKey: kPoolTypeMaxSpeedKey)
//        }
//        if minSpeed != nil {
//            dictionary.updateValue(minSpeed!, forKey: kPoolTypeMinSpeedKey)
//        }
//        if code != nil {
//            dictionary.updateValue(code!, forKey: kPoolTypeCodeKey)
//        }
//        if gpsTrackingRequired != nil {
//            dictionary.updateValue(gpsTrackingRequired!, forKey: kPoolTypeGpsTrackingRequiredKey)
//        }
//        if photoVerificationRequired != nil {
//            dictionary.updateValue(photoVerificationRequired!, forKey: kPoolTypePhotoVerificationRequiredKey)
//        }
//        if name != nil {
//            dictionary.updateValue(name!, forKey: kPoolTypeNameKey)
//        }
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
//        self.detail = aDecoder.decodeObjectForKey(kPoolTypeDetailKey) as? String
//        self.backgroundPicture = aDecoder.decodeObjectForKey(kPoolTypeBackgroundPictureKey) as? String
//        self.internalIdentifier = aDecoder.decodeObjectForKey(kPoolTypeInternalIdentifierKey) as? String
//        self.color = aDecoder.decodeObjectForKey(kPoolTypeColorKey) as? String
//        self.maxSpeed = aDecoder.decodeObjectForKey(kPoolTypeMaxSpeedKey) as? String
//        self.minSpeed = aDecoder.decodeObjectForKey(kPoolTypeMinSpeedKey) as? String
//        self.code = aDecoder.decodeObjectForKey(kPoolTypeCodeKey) as? String
//        self.gpsTrackingRequired = aDecoder.decodeObjectForKey(kPoolTypeGpsTrackingRequiredKey) as? String
//        self.photoVerificationRequired = aDecoder.decodeObjectForKey(kPoolTypePhotoVerificationRequiredKey) as? String
//        self.name = aDecoder.decodeObjectForKey(kPoolTypeNameKey) as? String
        
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(detail, forKey: kPoolTypeDetailKey)
//        aCoder.encodeObject(backgroundPicture, forKey: kPoolTypeBackgroundPictureKey)
//        aCoder.encodeObject(internalIdentifier, forKey: kPoolTypeInternalIdentifierKey)
//        aCoder.encodeObject(color, forKey: kPoolTypeColorKey)
//        aCoder.encodeObject(maxSpeed, forKey: kPoolTypeMaxSpeedKey)
//        aCoder.encodeObject(minSpeed, forKey: kPoolTypeMinSpeedKey)
//        aCoder.encodeObject(code, forKey: kPoolTypeCodeKey)
//        aCoder.encodeObject(gpsTrackingRequired, forKey: kPoolTypeGpsTrackingRequiredKey)
//        aCoder.encodeObject(photoVerificationRequired, forKey: kPoolTypePhotoVerificationRequiredKey)
//        aCoder.encodeObject(name, forKey: kPoolTypeNameKey)
    }
    
}
