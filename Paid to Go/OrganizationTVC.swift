//
//  OrganizationTVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 10/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
@objc protocol OrganizationDelegate {
    @objc optional func orgatizationLinked(_ error:String?, isLinked:Bool, row:Int, message:String?)
}
class OrganizationTVC: UITableViewCell {
    @IBAction func linkBtnAction(_ sender: Any) {
            guard let  parentVC = parentVC else {
                return
            }
        if nationalPool != Constants.consShared.ONE_INT {
            linkToOrganization(parentVC,isOrgLinked: isOrgLinked)
            return
        }
        parentVC.present(parentVC.alert("You can't remove National Pool."), animated: true, completion: nil)
    }
    @IBOutlet weak var countryLB: UILabel!
    @IBOutlet weak var linkOL: UIButton!
    @IBOutlet weak var companyNameLB: UILabel!
    @IBOutlet weak var bannerIV: UIImageView!
    @IBOutlet weak var mainView: UIView!
    var invitationId = Constants.consShared.ZERO_INT
    var parentVC:UIViewController?
    var isOrgLinked:Bool = false
    var nationalPool:Int? = Constants.consShared.ZERO_INT
    var organizationDelegate:OrganizationDelegate?
    var position:Int = Constants.consShared.ZERO_INT
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.cardView()
    }

    func linkToOrganization(_ parentVC:UIViewController, isOrgLinked: Bool)  {
        AppUtils.utilsShared.showProgressHud(parentVC)
        guard let userID = User.currentUser?.userId else {
            return
        }
        DataProvider.sharedInstance.acceptInvitation(userID, invitationsId: invitationId, isOrgLinked:isOrgLinked,completion: { (response, error) in
            AppUtils.utilsShared.dismissProgressHud(parentVC)
            
            if let error = error, error.isEmpty == false {
                if let delegate = self.organizationDelegate {
                    delegate.orgatizationLinked!(error, isLinked: false,row:self.position,message: nil)
                }
                return
            }
            
            if let res = response , let detail = res.detail, let isLinked = res.isLinked {
                if let delegate = self.organizationDelegate {
                    delegate.orgatizationLinked!(nil, isLinked: isLinked,row:self.position,message: detail)
                }
                self.linkOL.setTitle("Linked", for: .normal)
                self.linkOL.isEnabled = false
            }
        })
    }
    
}
