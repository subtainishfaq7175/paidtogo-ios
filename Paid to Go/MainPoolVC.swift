//
//  MainPoolVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 10/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

class MainPoolVC: BaseVc {
// Health fit ui elements
    @IBOutlet weak var calLB: UILabel!
    @IBOutlet weak var offsetLB: UILabel!
    @IBOutlet weak var traveledLB: UILabel!
    @IBOutlet weak var gasLB: UILabel!
    @IBOutlet weak var stepLB: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var hkDataTV: UITableView!
    @IBOutlet weak var activitySV: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.cardView()
        configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func configTableView()  {
        guard let nib = UINib(nibName: IdentifierConstants.idConsShared.LOCAL_POOL_TVC, bundle: nil) as? UINib  else {
            print("nib not founded")
            return
        }
        hkDataTV.estimatedRowHeight = Constants.consShared.HUNDRED_INT.toCGFloat
        hkDataTV.register(nib, forCellReuseIdentifier: IdentifierConstants.idConsShared.LOCAL_POOL_TVC)
        
    }
    override func viewDidLayoutSubviews() {
//        addTabs()
    }
    func addTabs()  {
        for index in 0 ... 2 {
            let activityTable = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.ACTIVITY_TABLE_VC) as! ActivityTableVC
            createTabVC(activityTable, frame: CGRect(x: self.activitySV.frame.size.width * index.toCGFloat, y: 0, width: self.activitySV.frame.size.width, height: self.activitySV.frame.size.height), scrollView: activitySV)
        }
        activitySV.contentSize = CGSize(width: activitySV.frame.width * 3.0, height: activitySV.frame.height)
    }
    func createTabVC(_ vc:UIViewController,frame:CGRect, scrollView :UIScrollView){
        vc.view.frame = frame
        self.addChildViewController(vc);
        scrollView.addSubview(vc.view);
        vc.didMove(toParentViewController: self)
    }
}

// MARK: - Extensions
extension MainPoolVC:UITableViewDelegate{
    
}
extension MainPoolVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierConstants.idConsShared.LOCAL_POOL_TVC, for: indexPath) as! LocalPoolTVC
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / Constants.consShared.THREE_INT.toCGFloat
    }
}
