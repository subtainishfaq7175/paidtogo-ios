//
//  IdentifierConstants.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 03/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation
class IdentifierConstants {
    //     MARK: - Singalton
    static let idConsShared = IdentifierConstants()
    private init(){
        
    }
//    storyboard ids
    var HOME_VC:String {return "HomeViewController"}
    var ADD_ORGANIZATION_VC:String {return "AddOrganizationVC"}
    var MAIN_POOL_VC:String {return "MainPoolVC"}
    var LINK_ORGANIZATION_VC:String {return "LinkOrganizationVC"}
    var MY_ORGANIZATIONS_VC:String {return "MyOrganizationsVC"}
    var ACCOUNT_VC:String {return "AccountVC"}


//    table view cell ids
    var LOCAL_POOL_TVC:String {return "LocalPoolTVC"}
    var ORGANIZATION_TVC:String {return "OrganizationTVC"}


}

