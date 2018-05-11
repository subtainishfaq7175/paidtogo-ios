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
//        DataProvider.sharedInstance.getInvitations((User.currentUser?.userId)!, completion: { (invitation, error) in
        DataProvider.sharedInstance.getInvitations("182", completion: { (invitations, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.showAlert(error)
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
        if let id = invitations[indexPath.row].id {
            cell.invitationId = id
        }
        if let company = invitations[indexPath.row].pool?.name {
            cell.companyNameLB.text = company
        }else {
            cell.companyNameLB.text = "Not available"
        }
        if let country = invitations[indexPath.row].pool?.country {
            cell.countryLB.text = country
        }else {
            cell.countryLB.text = "Not available"
        }
        if let url = invitations[indexPath.row].pool?.banner {
            cell.bannerIV.yy_setImage(with: URL(string:url), placeholder: #imageLiteral(resourceName: "ic_ph_organization_p4"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
                
            })

        }
        cell.parentVC = self
        return cell
    }
}
