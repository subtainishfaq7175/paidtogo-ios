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
    @IBOutlet weak var poolNameLb: UILabel!
    @IBOutlet weak var pointsLB: UILabel!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var calLB: UILabel!
    @IBOutlet weak var offsetLB: UILabel!
    @IBOutlet weak var traveledLB: UILabel!
    @IBOutlet weak var gasLB: UILabel!
    @IBOutlet weak var stepLB: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var hkDataTV: UITableView!
    @IBOutlet weak var activitySV: UIScrollView!
    var activities = [ActivityNotification]()
    var isSubView = false
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
        if activities.count > consShared.ZERO_INT && !isSubView {
//            hkDataTV.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.addTabs()
                self.isSubView = true
            }

        }
    }
    func addTabs()  {
        if activities.count > consShared.ZERO_INT {
            for index in consShared.ZERO_INT ... (activities.count - consShared.ONE_INT) {
                let activityTable = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.ACTIVITY_TABLE_VC) as! ActivityTableVC
                    activityTable.activity = activities[index]
                createTabVC(activityTable, frame: CGRect(x: (self.topView.frame.size.width) * index.toCGFloat, y: consShared.ZERO_INT.toCGFloat, width: self.topView.frame.size.width, height: self.activitySV.frame.size.height), scrollView: activitySV)
                activityTable.activityTV.reloadData()
            }
            activitySV.contentSize = CGSize(width: topView.frame.width * activities.count.toCGFloat, height: activitySV.frame.height)
        }
        
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
