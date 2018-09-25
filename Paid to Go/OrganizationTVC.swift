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
    @IBOutlet weak var poolTypelabel: UILabel!
    
    var invitationId = Constants.consShared.ZERO_INT
    
    var poolId = Constants.consShared.ZERO_INT
    var parentVC:UIViewController?
    var isOrgLinked:Bool = false
    var nationalPool:Int? = Constants.consShared.ZERO_INT
    var organizationDelegate:OrganizationDelegate?
    var position:Int = Constants.consShared.ZERO_INT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.cardView()
        poolTypelabel.cardView()
        bannerIV.cardView()
//        bannerIV.addBorders()
    }

    func linkToOrganization(_ parentVC:UIViewController, isOrgLinked: Bool)  {
        AppUtils.utilsShared.showProgressHud(parentVC)
        guard let userID = User.currentUser?.userId else {
            return
        }
        
        if isOrgLinked {
            DataProvider.sharedInstance.unSubcribePool(userID, poolId: poolId) { (response, error) in
                AppUtils.utilsShared.dismissProgressHud(parentVC)
                if error == nil {
                    self.linkOL.setTitle("Removed", for: .normal)
                    self.linkOL.isEnabled = false
                }
                NotificationCenter.default.post(name: .organizationLinked, object: nil, userInfo: nil)
            }
        } else {
            DataProvider.sharedInstance.subcribePool(userID, poolId: poolId) { (response, error) in
                AppUtils.utilsShared.dismissProgressHud(parentVC)
                if error == nil {
                    self.linkOL.setTitle("Linked", for: .normal)
                    self.linkOL.isEnabled = false
                    
                    self.organizationDelegate?.orgatizationLinked!(error, isLinked: !isOrgLinked, row: self.position, message: nil)
                    
                    NotificationCenter.default.post(name: .organizationLinked, object: nil, userInfo: nil)
                }
                
            }
        }
        
        
        
        
    }
    
}
