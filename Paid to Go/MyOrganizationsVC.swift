//
//  MyOrganizationsVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 14/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
@objc protocol ChildScollDelegate {
    @objc optional func tableview(should enableScroll:Bool)
}
class MyOrganizationsVC: BaseVc {

    @IBOutlet weak var addOrgContainerView: UIView!
    @IBOutlet weak var addOrgnizationView: GenCustomView!
    @IBOutlet weak var organiztionsTV: UITableView!
    var layoutCount = Constants.consShared.ZERO_INT
    override func viewDidLoad() {
        super.viewDidLoad()
        organiztionsTV.register(UINib(nibName: idConsShared.ORGANIZATION_TVC, bundle: nil), forCellReuseIdentifier: idConsShared.ORGANIZATION_TVC)
        organiztionsTV.estimatedRowHeight = Constants.consShared.HUNDRED_INT.toCGFloat
        addOrgnizationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .blue
    }
    override func viewDidLayoutSubviews() {
        if layoutCount == consShared.ONE_INT {
            organiztionsTV.contentInset = UIEdgeInsets(top: consShared.ZERO_INT.toCGFloat, left: consShared.ZERO_INT.toCGFloat, bottom: addOrgContainerView.frame.height, right: consShared.ZERO_INT.toCGFloat)
        }
        layoutCount += consShared.ONE_INT
    }
// get my organizations from server
    func getOrganizations()  {
        self.showProgressHud()
        //        DataProvider.sharedInstance.getInvitations((User.currentUser?.userId)!, completion: { (invitation, error) in
        DataProvider.sharedInstance.getInvitations("182", completion: { (invitations, error) in
            self.dismissProgressHud()
            
            if let error = error, error.isEmpty == false {
                self.showAlert(error)
                return
            }
            
            if error == nil && invitations != nil {
                
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func handleGesture(_ gesture:UIGestureRecognizer){
        guard let tapedView = gesture.view else{
            return
        }
        switch tapedView {
        case addOrgnizationView:
            self.navigationController?.pushViewController(StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: idConsShared.LINK_ORGANIZATION_VC) as! LinkOrganizationVC, animated: true)
            break
        default:
            break
        }
    }
}
extension MyOrganizationsVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == organiztionsTV {
           if  scrollView.contentOffset.y == consShared.ZERO_INT.toCGFloat {
                organiztionsTV.isScrollEnabled = false
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == organiztionsTV {
            if  scrollView.contentOffset.y == consShared.ZERO_INT.toCGFloat {
                organiztionsTV.isScrollEnabled = false
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == organiztionsTV {
            if  scrollView.contentOffset.y == consShared.ZERO_INT.toCGFloat {
                organiztionsTV.isScrollEnabled = false
            }
        }
    }
}
extension MyOrganizationsVC : ChildScollDelegate{
    func tableview(should enableScroll: Bool) {
        organiztionsTV.isScrollEnabled = enableScroll
    }
}
extension MyOrganizationsVC : UITableViewDelegate{
    
}
extension MyOrganizationsVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idConsShared.ORGANIZATION_TVC, for: indexPath) as! OrganizationTVC
        cell.selectionStyle = .none
//        if let id = invitations[indexPath.row].id {
//            cell.invitationId = id
//        }
//        if let company = invitations[indexPath.row].pool?.name, company != consShared.EMPTY_STR {
//            cell.companyNameLB.text = company
//        }else {
//            cell.companyNameLB.text = "Not available"
//        }
//        if let country = invitations[indexPath.row].pool?.country , country != consShared.EMPTY_STR{
//            cell.countryLB.text = country
//        }else {
//            cell.countryLB.text = "Not available"
//        }
//        if let url = invitations[indexPath.row].pool?.banner {
//            cell.bannerIV.yy_setImage(with: URL(string:url), placeholder: #imageLiteral(resourceName: "ic_ph_organization_p4"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
//
//            })
//
//        }
//        cell.parentVC = self
        return cell
    }
}

