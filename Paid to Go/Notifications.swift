//
//  Notifications.swift
//  Paid to Go
//
//  Created by Nahuel on 13/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

enum NotificationsHelper : String {
    
    case UserProfileUpdated = "user_profile_updated"
    case ProUserSubscriptionExpired = "pro_user_subscription_expired"
    case OrganizationLinked = "OrganizationLinked"
}

extension Foundation.Notification.Name {
    static let userProfileUpdated = Foundation.Notification.Name(
        rawValue: NotificationsHelper.UserProfileUpdated.rawValue)
    static let proUserSubscriptionExpired = Foundation.Notification.Name(
        rawValue: NotificationsHelper.ProUserSubscriptionExpired.rawValue)
    static let organizationLinked = Foundation.Notification.Name(
        rawValue: NotificationsHelper.OrganizationLinked.rawValue)
}
