//
//  MainPoolVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 10/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit

enum DateRange :String {
    case today = "TODAY"
    case thisWeek = "THIS WEEK"
    case thisMonth = "THIS MONTH"
}

protocol MainPoolVCDelegate {
    func dateRangeUpdated(withDateRange dateRange:DateRange);
}

class MainPoolVC: BaseVc {
// Health fit ui elements
    @IBOutlet weak var dateRangelabel: UILabel!
    @IBOutlet weak var noActiviteslabel: UILabel!
    @IBOutlet weak var dateRangeView: UIView!
    @IBOutlet weak var numberActiviteslabel: UILabel!
    
    @IBOutlet weak var poolNameLb: UILabel!
    @IBOutlet weak var pointsLB: UILabel!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var calLB: UILabel!
    @IBOutlet weak var offsetLB: UILabel!
    @IBOutlet weak var traveledLB: UILabel!
    @IBOutlet weak var gasLB: UILabel!
    @IBOutlet weak var stepLB: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var activitySV: UIScrollView!
    
    @IBOutlet weak var startActivityButton: UIButton!
    @IBOutlet weak var startActivityButtonView: UIView!
    
    var dateRange: DateRange? {
        didSet {
            self.dateRangelabel.text = self.dateRange?.rawValue
        }
    }
    var delegate: MainPoolVCDelegate?
    
    var activities = [ActivityNotification]()
    var isSubView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.cardView()
//        configTableView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainPoolVC.dateRangeViewTapped(_:)))
        dateRangeView.addGestureRecognizer(tapGesture)
        dateRangeView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        let count = activities.count
        if count > consShared.ZERO_INT && !isSubView {
            //            hkDataTV.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.addTabs()
                self.isSubView = true
            }
        } else if (!isSubView) {
            noActiviteslabel.isHidden = false
//            activitySV.isHidden = true
        }
    }
    
    //    func configureViews() {
    //        configureButtonView()
    //    }
    //
    //    func configureButtonView () {
    //
    //        startActivityButtonView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    //        startActivityButtonView.cardView()
    ////         startActivityButtonView.layer.cornerRadius = (startActivityButtonView.bounds.height / 2) - 2
    //    }
    
    func addTabs()  {
        let count = activities.count
        
        numberActiviteslabel.isHidden = activities.count < 1
        numberActiviteslabel.text = String(1) + " / " + String(activities.count)
        
        if count > consShared.ZERO_INT {
            for index in consShared.ZERO_INT ... (count - consShared.ONE_INT) {
                let activityTable = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: IdentifierConstants.idConsShared.ACTIVITY_TABLE_VC) as! ActivityTableVC
                activityTable.activity = activities[index]
                createTabVC(activityTable, frame: CGRect(x: (self.topView.frame.size.width) * index.toCGFloat, y: consShared.ZERO_INT.toCGFloat, width: self.topView.frame.size.width, height: self.activitySV.frame.size.height), scrollView: activitySV)
                activityTable.activityTV.reloadData()
            }
            activitySV.contentSize = CGSize(width: topView.frame.width * count.toCGFloat, height: activitySV.frame.height)
        }
        
    }
    
    func createTabVC(_ vc:UIViewController,frame:CGRect, scrollView :UIScrollView){
        vc.view.frame = frame
        self.addChildViewController(vc);
        scrollView.addSubview(vc.view);
        vc.didMove(toParentViewController: self)
    }
    
    @objc func dateRangeViewTapped(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "", message: "Select a date range.", preferredStyle: .actionSheet)
        
        let today = UIAlertAction(title: DateRange.today.rawValue, style: .default) { today in
            if self.dateRange != .today {
                self.dateRange = .today
                if let delegate = self.delegate {
                    delegate.dateRangeUpdated(withDateRange: self.dateRange!)
                }
                
            }
        }
        
        let thisWeek = UIAlertAction(title: DateRange.thisWeek.rawValue, style: .default) { today in
            if self.dateRange != .thisWeek {
                self.dateRange = .thisWeek
                if let delegate = self.delegate {
                    delegate.dateRangeUpdated(withDateRange: self.dateRange!)
                }
                
            }
        }
        
        let thisMonth = UIAlertAction(title: DateRange.thisMonth.rawValue, style: .default) { today in
            if self.dateRange != .thisMonth {
                self.dateRange = .thisMonth
                if let delegate = self.delegate {
                    delegate.dateRangeUpdated(withDateRange: self.dateRange!)
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(today)
        alertController.addAction(thisWeek)
        alertController.addAction(thisMonth)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension MainPoolVC :UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedIndex = scrollView.currentPage
        numberActiviteslabel.text = String(selectedIndex + 1) + " / " + String(activities.count)
    }
}

extension MainPoolVC:UITableViewDelegate {
    
}

extension MainPoolVC:UITableViewDataSource {
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
