//
//  LinkOrganizationVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 10/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class LinkOrganizationVC: BaseVc {

    @IBOutlet weak var organizationTV: UITableView!
    @IBOutlet weak var organizationSearch: UISearchBar!
    var invitations = [Invitations]()
    override func viewDidLoad() {
        super.viewDidLoad()
        organizationTV.register(UINib(nibName: idConsShared.ORGANIZATION_TVC, bundle: nil), forCellReuseIdentifier: idConsShared.ORGANIZATION_TVC)
        organizationTV.estimatedRowHeight = Constants.consShared.HUNDRED_INT.toCGFloat
        // Do any additional setup after loading the view.
        getInvitations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func getInvitations()  {
        self.showProgressHud()
        DataProvider.sharedInstance.getInvitations((User.currentUser?.userId)!, completion: { (invitations, error) in
//        DataProvider.sharedInstance.getInvitations("182", completion: { (invitations, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.present(self.alert(error), animated: true, completion: nil)
                return
            }
            
            if error == nil && invitations != nil {
                self.invitations = invitations!
                self.organizationTV.reloadData()
                print("\(invitations)")
            }
        })
    }
  
}
// MARK: - searchbar delegate
extension LinkOrganizationVC : UISearchBarDelegate{
    
}
// MARK: - uitableview datsource and delegate

extension LinkOrganizationVC : UITableViewDelegate{
    
}
extension LinkOrganizationVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idConsShared.ORGANIZATION_TVC, for: indexPath) as! OrganizationTVC
        cell.selectionStyle = .none
        if let id = invitations[indexPath.row].idStr {
            //            MARK: - NEED TO CAST TO INT FROM SERVER
            if let invitationId = Int(id) {
                cell.invitationId = invitationId
            }else {
                cell.invitationId = consShared.ZERO_INT
            }
        }
        if let company = invitations[indexPath.row].pool?.name, company != consShared.EMPTY_STR {
            cell.companyNameLB.text = company
        }else {
            cell.companyNameLB.text = "Not available"
        }
        if let country = invitations[indexPath.row].pool?.country , country != consShared.EMPTY_STR{
            cell.countryLB.text = country
        }else {
            cell.countryLB.text = "Not available"
        }
        if let url = invitations[indexPath.row].pool?.banner {
            //            MARK: - NEED TO GET COMPLETE URL FROM SERVER
            let  completeUrl = "https://www.paidtogo.com/images/pools/"+url
            cell.bannerIV.yy_setImage(with: URL(string:completeUrl), placeholder: #imageLiteral(resourceName: "ic_paidtogo"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
                
            })

        }
        cell.parentVC = self
        return cell
    }
}
