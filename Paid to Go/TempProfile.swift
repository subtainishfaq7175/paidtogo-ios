//
//  TempProfile.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 14/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class TempProfile: BaseVc {

    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var profilePhotoView: GenCustomView!
    @IBOutlet weak var editView: GenCustomView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var childSV: UIScrollView!
    @IBOutlet weak var parentSV: UIScrollView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
//    tab buttons and their bottom views
    @IBOutlet weak var accountBottomView: UIView!
    @IBAction func accountAction(_ sender: Any) {
        selectedButton(accountOL, bottomView: accountBottomView)
        unselectedButton(organizationsOL, bottomView: organizationBottomView)
        parentSV.scrollRectToVisible(CGRect(x: consShared.ZERO_INT.toCGFloat, y: consShared.ZERO_INT.toCGFloat, width: self.view.frame.size.width, height: self.view.frame.size.height), animated: true)
    }
    @IBOutlet weak var accountOL: UIButton!
    @IBOutlet weak var organizationBottomView: UIView!
    @IBOutlet weak var organizationsOL: UIButton!
    @IBAction func organizationsAction(_ sender: Any) {
        selectedButton(organizationsOL, bottomView: organizationBottomView)
        unselectedButton(accountOL, bottomView: accountBottomView)
        parentSV.scrollRectToVisible(CGRect(x: self.view.frame.size.width, y: consShared.ZERO_INT.toCGFloat, width: self.view.frame.size.width, height: self.view.frame.size.height), animated: true)
    }
    var layoutCounter:Int = Constants.consShared.ZERO_INT
    var scrollDelegate:ChildScollDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        if layoutCounter == consShared.ONE_INT {
            addTabs()
            self.profilePhotoView.addConstraint(NSLayoutConstraint(item: profilePhotoView, attribute: .bottom, relatedBy: .equal, toItem: editView, attribute: .bottom, multiplier: consShared.ONE_INT.toCGFloat, constant: -(editView.frame.size.height * 0.5)))
        }
        layoutCounter += consShared.ONE_INT
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK: - Tab buttons makeup
    func selectedButton(_ btn:UIButton, bottomView:UIView)  {
        guard let titleLabel = btn.titleLabel else {
            return
        }
        titleLabel.font = UIFont(name: consShared.OPEN_SANS_SEMIBOLD, size: titleLabel.font.pointSize)
        bottomView.backgroundColor = colorShared.springGreen
       
    }
    func unselectedButton(_ btn:UIButton, bottomView:UIView)  {
        guard let titleLabel = btn.titleLabel else {
            return
        }
        titleLabel.font = UIFont(name: consShared.OPEN_SANS_LIGHT, size: titleLabel.font.pointSize)
        bottomView.backgroundColor = UIColor.white
        
        
    }
    // MARK: - Tabs Navigation
    func createTabVC(_ vc:UIViewController,frame:CGRect){
        vc.view.frame = frame
        self.addChildViewController(vc);
        self.childSV!.addSubview(vc.view);
        vc.didMove(toParentViewController: self)
    }
    func addTabs(){
     createTabVC(StoryboardRouter.profileStoryboard().instantiateViewController(withIdentifier: idConsShared.ACCOUNT_VC) as! AccountVC, frame: CGRect(x: consShared.ZERO_INT.toCGFloat, y: consShared.ZERO_INT.toCGFloat, width: self.view.frame.size.width, height: childSV.frame.size.height))

         let myOrganization = StoryboardRouter.profileStoryboard().instantiateViewController(withIdentifier: idConsShared.MY_ORGANIZATIONS_VC) as! MyOrganizationsVC
            scrollDelegate = myOrganization
        createTabVC(myOrganization, frame: CGRect(x: self.view.frame.size.width, y: consShared.ZERO_INT.toCGFloat, width: self.view.frame.size.width, height: childSV.frame.size.height))
        self.childSV.contentSize = CGSize(width: view.frame.width * consShared.TWO_INT.toCGFloat, height: childSV.frame.size.height)
    }
}

extension TempProfile : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y * 0.5
        self.topView.frame = CGRect(x: 0, y: yOffset, width: topView.frame.width, height: topView.frame.height)
        if yOffset == consShared.ZERO_INT.toCGFloat {
            topView.layer.opacity = consShared.ONE_INT.toFloat

        }else {
            topView.layer.opacity = consShared.ONE_INT.toFloat -  Float((yOffset / 100))

        }
        guard let delegate = scrollDelegate else {
            return
        }
        print("\(self.view.frame.size.height * 0.35), \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y  >= (self.view.frame.size.height * 0.35){
            delegate.tableview!(should: true)
        }else {
            delegate.tableview!(should: false)

        }
//        if childSV == scrollView {
//            topConstraint.constant =  topConstraint.constant - scrollView.contentOffset.y
//        }
    }
    
}
