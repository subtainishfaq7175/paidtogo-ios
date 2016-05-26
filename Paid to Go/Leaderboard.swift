//
//  Leaderboard.swift
//
//  Created by MacbookPro on 26/5/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class Leaderboard: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kLeaderboardUserIdKey: String = "user_id"
	internal let kLeaderboardLastNameKey: String = "last_name"
	internal let kLeaderboardProfilePictureKey: String = "profile_picture"
	internal let kLeaderboardFirstNameKey: String = "first_name"
	internal let kLeaderboardPlaceKey: String = "place"


    // MARK: Properties
	public var userId: String?
	public var lastName: String?
	public var profilePicture: String?
	public var firstName: String?
	public var place: Int?



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
		userId <- map[kLeaderboardUserIdKey]
		lastName <- map[kLeaderboardLastNameKey]
		profilePicture <- map[kLeaderboardProfilePictureKey]
		firstName <- map[kLeaderboardFirstNameKey]
		place <- map[kLeaderboardPlaceKey]

    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if userId != nil {
			dictionary.updateValue(userId!, forKey: kLeaderboardUserIdKey)
		}
		if lastName != nil {
			dictionary.updateValue(lastName!, forKey: kLeaderboardLastNameKey)
		}
		if profilePicture != nil {
			dictionary.updateValue(profilePicture!, forKey: kLeaderboardProfilePictureKey)
		}
		if firstName != nil {
			dictionary.updateValue(firstName!, forKey: kLeaderboardFirstNameKey)
		}
		if place != nil {
			dictionary.updateValue(place!, forKey: kLeaderboardPlaceKey)
		}

        return dictionary
    }

}
