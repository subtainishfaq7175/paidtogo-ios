//
//  LeaderboardsResponse.swift
//
//  Created by MacbookPro on 26/5/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class LeaderboardsResponse: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kLeaderboardsResponseLeaderboardKey: String = "leaderboard"
	internal let kLeaderboardsResponsePoolIdKey: String = "pool_id"
	internal let kLeaderboardsResponseIconPhotoDescriptionKey: String = "icon_photo_description"
	internal let kLeaderboardsResponseIconPhotoKey: String = "icon_photo"
	internal let kLeaderboardsResponseNameKey: String = "name"
    internal let kLeaderboardsResponseEndDateTime: String = "end_date_time"
    internal let kLeaderboardsResponsePoolTypeName: String = "pool_types_name"

    // MARK: Properties
	public var leaderboard: [Leaderboard]?
	public var poolId: String?
	public var iconPhotoDescription: String?
	public var iconPhoto: String?
	public var name: String?
    public var endDateTime: String?
    public var poolTypeName: String?

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
        
		leaderboard <- map[kLeaderboardsResponseLeaderboardKey]
		poolId <- map[kLeaderboardsResponsePoolIdKey]
		iconPhotoDescription <- map[kLeaderboardsResponseIconPhotoDescriptionKey]
		iconPhoto <- map[kLeaderboardsResponseIconPhotoKey]
		name <- map[kLeaderboardsResponseNameKey]
        endDateTime <- map[kLeaderboardsResponseEndDateTime]
        poolTypeName <- map[kLeaderboardsResponsePoolTypeName]
    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if (leaderboard?.count)! > 0 {
			var temp: [AnyObject] = []
			for item in leaderboard! {
                temp.append(item.dictionaryRepresentation() as AnyObject)
			}
            dictionary.updateValue(temp as AnyObject, forKey: kLeaderboardsResponseLeaderboardKey)
		}
		if poolId != nil {
            dictionary.updateValue(poolId! as AnyObject, forKey: kLeaderboardsResponsePoolIdKey)
		}
		if iconPhotoDescription != nil {
            dictionary.updateValue(iconPhotoDescription! as AnyObject, forKey: kLeaderboardsResponseIconPhotoDescriptionKey)
		}
		if iconPhoto != nil {
            dictionary.updateValue(iconPhoto! as AnyObject, forKey: kLeaderboardsResponseIconPhotoKey)
		}
		if name != nil {
            dictionary.updateValue(name! as AnyObject, forKey: kLeaderboardsResponseNameKey)
		}

        return dictionary
    }

}
