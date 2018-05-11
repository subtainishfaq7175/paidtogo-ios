//
//  AddOrganizationVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 09/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class AddOrganizationVC: BaseVc {

    @IBOutlet weak var adOrganizationView: GenCustomView!
    @IBOutlet weak var dailyEarningsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyEarningsView.cardView()
        adOrganizationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))
        // Do any additional setup after loading the view.
    }
    @objc func handleGesture(_ gesture:UIGestureRecognizer){
        guard let tapedView = gesture.view else{
            return
        }
        switch tapedView {
        case adOrganizationView:
            self.navigationController?.pushViewController(StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: idConsShared.LINK_ORGANIZATION_VC) as! LinkOrganizationVC, animated: true)
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
