//
//  OrganizationTVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 10/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class OrganizationTVC: UITableViewCell {

    @IBAction func linkBtnAction(_ sender: Any) {
        if invitationId != Constants.consShared.ZERO_INT {
            guard let  parentVC = parentVC else {
                return
            }
            linkToOrganization(parentVC)
        }
    }
    @IBOutlet weak var countryLB: UILabel!
    @IBOutlet weak var linkOL: UIButton!
    @IBOutlet weak var companyNameLB: UILabel!
    @IBOutlet weak var bannerIV: UIImageView!
    @IBOutlet weak var mainView: UIView!
    var invitationId = Constants.consShared.ZERO_INT
    var parentVC:LinkOrganizationVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.cardView()
        // Initialization code
    }

    func linkToOrganization(_ parentVC:LinkOrganizationVC)  {
        AppUtils.utilsShared.showProgressHud(parentVC)
        DataProvider.sharedInstance.acceptInvitation("182", invitationsId: invitationId, completion: { (response, error) in
            AppUtils.utilsShared.dismissProgressHud(parentVC)
            
            if let error = error, error.isEmpty == false {
                parentVC.showAlert(error)
                return
            }
            
            if let res = response , let detail = res.detail {
                parentVC.showAlert(detail)
            }
        })
    }
    
}
