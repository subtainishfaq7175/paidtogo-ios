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

    internal let kActive_commuteKey: String = "active_commute"
    internal let kExerciseKey: String = "exercise"

    // MARK: Properties
	public var userId: String?
	public var lastName: String?
	public var profilePicture: String?
	public var firstName: String?
	public var place: Int?
    
    public var activeCommutes: [LeaderboardPosition]? = [LeaderboardPosition]()
    public var exercices: [LeaderboardPosition]? = [LeaderboardPosition]()

    
    var firstActiveCommuteEarned_money: Double?
    var firstActiveCommuteEarned_points: Double?
    var firstExerciceEarned_money: Double?
    var firstExerciceEarned_points: Double?
    
    var profile_picture: String?
    
    // MARK: ObjectMapper Initalizers
    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    required public init?(map: Map){

    }
    
    init() {
        firstActiveCommuteEarned_money = 0
        firstActiveCommuteEarned_points = 0
        firstExerciceEarned_money = 0
        firstExerciceEarned_points = 0
    }
    

    /**
    Map a JSON object to this class using ObjectMapper
    - parameter map: A mapping from ObjectMapper
    */
    public func mapping(map: Map) {
		userId <- map[kLeaderboardUserIdKey]
		lastName <- map[kLeaderboardLastNameKey]
		profilePicture <- map[kLeaderboardProfilePictureKey]
		firstName <- map[kLeaderboardFirstNameKey]
		place <- map[kLeaderboardPlaceKey]
      
        activeCommutes <- map[kActive_commuteKey]
        exercices <- map[kExerciseKey]
        
        if let first = activeCommutes?.first {
            firstActiveCommuteEarned_money = first.earned_money
            firstActiveCommuteEarned_points = first.earned_points
            profile_picture = first.profile_picture
        }
        
        if let first = exercices?.first {
            firstExerciceEarned_money = first.earned_money
            firstExerciceEarned_points = first.earned_points
            profile_picture = first.profile_picture
        }
        
        if firstExerciceEarned_money == nil {
            firstExerciceEarned_money = 0
        }
        
        if firstExerciceEarned_points == nil {
            firstExerciceEarned_points = 0
        }
    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if userId != nil {
            dictionary.updateValue(userId! as AnyObject, forKey: kLeaderboardUserIdKey)
		}
		if lastName != nil {
            dictionary.updateValue(lastName! as AnyObject, forKey: kLeaderboardLastNameKey)
		}
		if profilePicture != nil {
            dictionary.updateValue(profilePicture! as AnyObject, forKey: kLeaderboardProfilePictureKey)
		}
		if firstName != nil {
            dictionary.updateValue(firstName! as AnyObject, forKey: kLeaderboardFirstNameKey)
		}
		if place != nil {
            dictionary.updateValue(place! as AnyObject, forKey: kLeaderboardPlaceKey)
		}

        return dictionary
    }

}
